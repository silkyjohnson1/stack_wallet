import 'package:isar/isar.dart';
import 'package:stackwallet/models/balance.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/address.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/transaction.dart';
import 'package:stackwallet/models/node_model.dart';
import 'package:stackwallet/models/paymint/fee_object_model.dart';
import 'package:stackwallet/services/node_service.dart';
import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/utilities/default_nodes.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/extensions/impl/string.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/wallets/api/tezos/tezos_account.dart';
import 'package:stackwallet/wallets/api/tezos/tezos_api.dart';
import 'package:stackwallet/wallets/api/tezos/tezos_rpc_api.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/tezos.dart';
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart';
import 'package:stackwallet/wallets/models/tx_data.dart';
import 'package:stackwallet/wallets/wallet/intermediate/bip39_wallet.dart';
import 'package:tezart/tezart.dart' as tezart;
import 'package:tuple/tuple.dart';

// const kDefaultTransactionStorageLimit = 496;
// const kDefaultTransactionGasLimit = 10600;
//
// const kDefaultKeyRevealFee = 1270;
// const kDefaultKeyRevealStorageLimit = 0;
// const kDefaultKeyRevealGasLimit = 1100;

class TezosWallet extends Bip39Wallet {
  TezosWallet(CryptoCurrencyNetwork network) : super(Tezos(network));

  NodeModel? _xtzNode;

  Future<tezart.Keystore> _getKeyStore() async {
    final mnemonic = await getMnemonic();
    final passphrase = await getMnemonicPassphrase();
    return tezart.Keystore.fromMnemonic(mnemonic, password: passphrase);
  }

  Future<Address> _getAddressFromMnemonic() async {
    final keyStore = await _getKeyStore();
    return Address(
      walletId: walletId,
      value: keyStore.address,
      publicKey: keyStore.publicKey.toUint8ListFromBase58CheckEncoded,
      derivationIndex: 0,
      derivationPath: null,
      type: info.coin.primaryAddressType,
      subType: AddressSubType.receiving,
    );
  }

  Future<tezart.OperationsList> _buildSendTransaction({
    required Amount amount,
    required String address,
    required int counter,
    // required bool reveal,
    // int? customGasLimit,
    // Amount? customFee,
    // Amount? customRevealFee,
  }) async {
    try {
      final sourceKeyStore = await _getKeyStore();
      final server = (_xtzNode ?? getCurrentNode()).host;
      // if (kDebugMode) {
      //   print("SERVER: $server");
      //   print("COUNTER: $counter");
      //   print("customFee: $customFee");
      // }
      final tezartClient = tezart.TezartClient(
        server,
      );

      final opList = await tezartClient.transferOperation(
        source: sourceKeyStore,
        destination: address,
        amount: amount.raw.toInt(),
        // customFee: customFee?.raw.toInt(),
        // customGasLimit: customGasLimit,
        // reveal: false,
      );

      // if (reveal) {
      //   opList.prependOperation(
      //     tezart.RevealOperation(
      //       customGasLimit: customGasLimit,
      //       customFee: customRevealFee?.raw.toInt(),
      //     ),
      //   );
      // }

      for (final op in opList.operations) {
        op.counter = counter;
        counter++;
      }

      return opList;
    } catch (e, s) {
      Logging.instance.log(
        "Error in _buildSendTransaction() in tezos_wallet.dart: $e\n$s}",
        level: LogLevel.Error,
      );
      rethrow;
    }
  }

  // ===========================================================================

  @override
  Future<void> init() async {
    final _address = await getCurrentReceivingAddress();
    if (_address == null) {
      final address = await _getAddressFromMnemonic();

      await mainDB.updateOrPutAddresses([address]);
    }

    await super.init();
  }

  @override
  FilterOperation? get changeAddressFilterOperation =>
      throw UnimplementedError("Not used for $runtimeType");

  @override
  FilterOperation? get receivingAddressFilterOperation =>
      FilterGroup.and(standardReceivingAddressFilters);

  @override
  Future<TxData> prepareSend({required TxData txData}) async {
    try {
      if (txData.recipients == null || txData.recipients!.length != 1) {
        throw Exception("$runtimeType prepareSend requires 1 recipient");
      }

      Amount sendAmount = txData.amount!;

      if (sendAmount > info.cachedBalance.spendable) {
        throw Exception("Insufficient available balance");
      }
      final account = await TezosAPI.getAccount(
        (await getCurrentReceivingAddress())!.value,
      );

      // final bool isSendAll = sendAmount == info.cachedBalance.spendable;
      //
      // int? customGasLimit;
      // Amount? fee;
      // Amount? revealFee;
      //
      // if (isSendAll) {
      //   final fees = await _estimate(
      //     account,
      //     txData.recipients!.first.address,
      //   );
      //   //Fee guides for emptying a tz account
      //   // https://github.com/TezTech/eztz/blob/master/PROTO_004_FEES.md
      //   // customGasLimit = kDefaultTransactionGasLimit + 320;
      //   fee = Amount(
      //     rawValue: BigInt.from(fees.transfer + 32),
      //     fractionDigits: cryptoCurrency.fractionDigits,
      //   );
      //
      //   BigInt rawAmount = sendAmount.raw - fee.raw;
      //
      //   if (!account.revealed) {
      //     revealFee = Amount(
      //       rawValue: BigInt.from(fees.reveal + 32),
      //       fractionDigits: cryptoCurrency.fractionDigits,
      //     );
      //
      //     rawAmount = rawAmount - revealFee.raw;
      //   }
      //
      //   sendAmount = Amount(
      //     rawValue: rawAmount,
      //     fractionDigits: cryptoCurrency.fractionDigits,
      //   );
      // }

      final opList = await _buildSendTransaction(
        amount: sendAmount,
        address: txData.recipients!.first.address,
        counter: account.counter + 1,
        // reveal: !account.revealed,
        // customFee: isSendAll ? fee : null,
        // customRevealFee: isSendAll ? revealFee : null,
        // customGasLimit: customGasLimit,
      );

      await opList.computeLimits();
      await opList.computeFees();
      await opList.simulate();

      return txData.copyWith(
        recipients: [
          (
            amount: sendAmount,
            address: txData.recipients!.first.address,
          )
        ],
        // fee: fee,
        fee: Amount(
          rawValue: opList.operations
              .map(
                (e) => BigInt.from(e.fee),
              )
              .fold(
                BigInt.zero,
                (p, e) => p + e,
              ),
          fractionDigits: cryptoCurrency.fractionDigits,
        ),
        tezosOperationsList: opList,
      );
    } catch (e, s) {
      Logging.instance.log(
        "Error in prepareSend() in tezos_wallet.dart: $e\n$s}",
        level: LogLevel.Error,
      );

      if (e
          .toString()
          .contains("(_operationResult['errors']): Must not be null")) {
        throw Exception("Probably insufficient balance");
      } else if (e.toString().contains(
            "The simulation of the operation: \"transaction\" failed with error(s) :"
            " contract.balance_too_low, tez.subtraction_underflow.",
          )) {
        throw Exception("Insufficient balance to pay fees");
      }

      rethrow;
    }
  }

  @override
  Future<TxData> confirmSend({required TxData txData}) async {
    await txData.tezosOperationsList!.inject();
    await txData.tezosOperationsList!.monitor();
    return txData.copyWith(
      txid: txData.tezosOperationsList!.result.id,
    );
  }

  int _estCount = 0;

  Future<({int reveal, int transfer})> _estimate(
      TezosAccount account, String recipientAddress) async {
    try {
      final opList = await _buildSendTransaction(
        amount: Amount(
          rawValue: BigInt.one,
          fractionDigits: cryptoCurrency.fractionDigits,
        ),
        address: recipientAddress,
        counter: account.counter + 1,
        // reveal: !account.revealed,
      );

      await opList.computeLimits();
      await opList.computeFees();
      await opList.simulate();

      int reveal = 0;
      int transfer = 0;

      for (final op in opList.operations) {
        if (op is tezart.TransactionOperation) {
          transfer += op.fee;
        } else if (op is tezart.RevealOperation) {
          reveal += op.fee;
        }
      }

      return (reveal: reveal, transfer: transfer);
    } catch (e, s) {
      if (_estCount > 3) {
        _estCount = 0;
        Logging.instance.log(
          " Error in _estimate in tezos_wallet.dart: $e\n$s}",
          level: LogLevel.Error,
        );
        rethrow;
      } else {
        _estCount++;
        Logging.instance.log(
          "_estimate() retry _estCount=$_estCount",
          level: LogLevel.Warning,
        );
        return await _estimate(
          account,
          recipientAddress,
        );
      }
    }
  }

  @override
  Future<Amount> estimateFeeFor(
    Amount amount,
    int feeRate, {
    String recipientAddress = "tz1MXvDCyXSqBqXPNDcsdmVZKfoxL9FTHmp2",
  }) async {
    if (info.cachedBalance.spendable.raw == BigInt.zero) {
      return Amount(
        rawValue: BigInt.zero,
        fractionDigits: cryptoCurrency.fractionDigits,
      );
    }

    final account = await TezosAPI.getAccount(
      (await getCurrentReceivingAddress())!.value,
    );

    try {
      final fees = await _estimate(account, recipientAddress);

      final fee = Amount(
        rawValue: BigInt.from(fees.reveal + fees.transfer),
        fractionDigits: cryptoCurrency.fractionDigits,
      );

      return fee;
    } catch (e, s) {
      Logging.instance.log(
        "  Error in estimateFeeFor() in tezos_wallet.dart: $e\n$s}",
        level: LogLevel.Error,
      );
      rethrow;
    }
  }

  /// Not really used (yet)
  @override
  Future<FeeObject> get fees async {
    const feePerTx = 1;
    return FeeObject(
      numberOfBlocksFast: 10,
      numberOfBlocksAverage: 10,
      numberOfBlocksSlow: 10,
      fast: feePerTx,
      medium: feePerTx,
      slow: feePerTx,
    );
  }

  @override
  Future<bool> pingCheck() async {
    final currentNode = getCurrentNode();
    return await TezosRpcAPI.testNetworkConnection(
      nodeInfo: (
        host: currentNode.host,
        port: currentNode.port,
      ),
    );
  }

  @override
  Future<void> recover({required bool isRescan}) async {
    await refreshMutex.protect(() async {
      if (isRescan) {
        await mainDB.deleteWalletBlockchainData(walletId);
      }

      final address = await _getAddressFromMnemonic();

      await mainDB.updateOrPutAddresses([address]);

      await Future.wait([
        updateBalance(),
        updateTransactions(),
        updateChainHeight(),
      ]);
    });
  }

  @override
  Future<void> updateBalance() async {
    try {
      final currentNode = _xtzNode ?? getCurrentNode();
      final balance = await TezosRpcAPI.getBalance(
        nodeInfo: (host: currentNode.host, port: currentNode.port),
        address: (await getCurrentReceivingAddress())!.value,
      );

      final balanceInAmount = Amount(
        rawValue: balance!,
        fractionDigits: cryptoCurrency.fractionDigits,
      );
      final newBalance = Balance(
        total: balanceInAmount,
        spendable: balanceInAmount,
        blockedTotal: Amount(
          rawValue: BigInt.zero,
          fractionDigits: cryptoCurrency.fractionDigits,
        ),
        pendingSpendable: Amount(
          rawValue: BigInt.zero,
          fractionDigits: cryptoCurrency.fractionDigits,
        ),
      );

      await info.updateBalance(newBalance: newBalance, isar: mainDB.isar);
    } catch (e, s) {
      Logging.instance.log(
        "Error getting balance in tezos_wallet.dart: $e\n$s}",
        level: LogLevel.Error,
      );
    }
  }

  @override
  Future<void> updateChainHeight() async {
    try {
      final currentNode = _xtzNode ?? getCurrentNode();
      final height = await TezosRpcAPI.getChainHeight(
        nodeInfo: (
          host: currentNode.host,
          port: currentNode.port,
        ),
      );

      await info.updateCachedChainHeight(
        newHeight: height!,
        isar: mainDB.isar,
      );
    } catch (e, s) {
      Logging.instance.log(
        "Error occurred in tezos_wallet.dart while getting"
        " chain height for tezos: $e\n$s}",
        level: LogLevel.Error,
      );
    }
  }

  @override
  Future<void> updateNode() async {
    _xtzNode = NodeService(secureStorageInterface: secureStorageInterface)
            .getPrimaryNodeFor(coin: info.coin) ??
        DefaultNodes.getNodeFor(info.coin);

    await refresh();
  }

  @override
  NodeModel getCurrentNode() {
    return _xtzNode ??
        NodeService(secureStorageInterface: secureStorageInterface)
            .getPrimaryNodeFor(coin: info.coin) ??
        DefaultNodes.getNodeFor(info.coin);
  }

  @override
  Future<void> updateTransactions() async {
    // TODO: optimize updateTransactions

    final myAddress = (await getCurrentReceivingAddress())!;
    final txs = await TezosAPI.getTransactions(myAddress.value);

    if (txs.isEmpty) {
      return;
    }

    List<Tuple2<Transaction, Address>> transactions = [];
    for (final theTx in txs) {
      final TransactionType txType;

      if (myAddress.value == theTx.senderAddress) {
        txType = TransactionType.outgoing;
      } else if (myAddress.value == theTx.receiverAddress) {
        if (myAddress.value == theTx.senderAddress) {
          txType = TransactionType.sentToSelf;
        } else {
          txType = TransactionType.incoming;
        }
      } else {
        txType = TransactionType.unknown;
      }

      var transaction = Transaction(
        walletId: walletId,
        txid: theTx.hash,
        timestamp: theTx.timestamp,
        type: txType,
        subType: TransactionSubType.none,
        amount: theTx.amountInMicroTez,
        amountString: Amount(
          rawValue: BigInt.from(theTx.amountInMicroTez),
          fractionDigits: cryptoCurrency.fractionDigits,
        ).toJsonString(),
        fee: theTx.feeInMicroTez,
        height: theTx.height,
        isCancelled: false,
        isLelantus: false,
        slateId: "",
        otherData: "",
        inputs: [],
        outputs: [],
        nonce: 0,
        numberOfMessages: null,
      );

      final Address theAddress;
      switch (txType) {
        case TransactionType.incoming:
        case TransactionType.sentToSelf:
          theAddress = myAddress;
          break;
        case TransactionType.outgoing:
        case TransactionType.unknown:
          theAddress = Address(
            walletId: walletId,
            value: theTx.receiverAddress,
            publicKey: [],
            derivationIndex: 0,
            derivationPath: null,
            type: AddressType.unknown,
            subType: AddressSubType.unknown,
          );
          break;
      }
      transactions.add(Tuple2(transaction, theAddress));
    }
    await mainDB.addNewTransactionData(transactions, walletId);
  }

  @override
  Future<void> updateUTXOs() async {
    // do nothing. Not used in tezos
  }
}
