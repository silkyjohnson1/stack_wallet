import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart';
import 'package:isar/isar.dart';
import 'package:stackwallet/models/balance.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/address.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/transaction.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/utxo.dart';
import 'package:stackwallet/models/paymint/fee_object_model.dart';
import 'package:stackwallet/services/coins/coin_service.dart';
import 'package:stackwallet/services/node_service.dart';
import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/default_nodes.dart';
import 'package:stackwallet/utilities/enums/fee_rate_type_enum.dart';

import 'package:tezart/tezart.dart';
import 'package:tuple/tuple.dart';

import '../../../db/isar/main_db.dart';
import '../../../models/node_model.dart';
import '../../../utilities/flutter_secure_storage_interface.dart';
import '../../../utilities/logger.dart';
import '../../../utilities/prefs.dart';
import '../../mixins/wallet_cache.dart';
import '../../mixins/wallet_db.dart';
import '../../transaction_notification_tracker.dart';

const int MINIMUM_CONFIRMATIONS = 1;

class TezosWallet extends CoinServiceAPI with WalletCache, WalletDB {
  TezosWallet({
    required String walletId,
    required String walletName,
    required Coin coin,
    required SecureStorageInterface secureStore,
    required TransactionNotificationTracker tracker,
    MainDB? mockableOverride,
  }) {
    txTracker = tracker;
    _walletId = walletId;
    _walletName = walletName;
    _coin = coin;
    _secureStore = secureStore;
    initCache(walletId, coin);
    initWalletDB(mockableOverride: mockableOverride);
  }

  NodeModel? _xtzNode;

  NodeModel getCurrentNode() {
    return _xtzNode ?? NodeService(secureStorageInterface: _secureStore).getPrimaryNodeFor(coin: Coin.tezos) ?? DefaultNodes.getNodeFor(Coin.tezos);
  }

  Future<Keystore> getKeystore() async {
    return Keystore.fromMnemonic((await mnemonicString).toString());
  }

  @override
  String get walletId => _walletId;
  late String _walletId;

  @override
  String get walletName => _walletName;
  late String _walletName;

  @override
  set walletName(String name) => _walletName = name;

  @override
  set isFavorite(bool markFavorite) {
    _isFavorite = markFavorite;
    updateCachedIsFavorite(markFavorite);
  }

  @override
  bool get isFavorite => _isFavorite ??= getCachedIsFavorite();
  bool? _isFavorite;

  @override
  Coin get coin => _coin;
  late Coin _coin;

  late SecureStorageInterface _secureStore;
  late final TransactionNotificationTracker txTracker;
  final _prefs = Prefs.instance;

  Timer? timer;
  bool _shouldAutoSync = false;

  @override
  bool get shouldAutoSync => _shouldAutoSync;

  @override
  set shouldAutoSync(bool shouldAutoSync) {
    if (_shouldAutoSync != shouldAutoSync) {
      _shouldAutoSync = shouldAutoSync;
      if (!shouldAutoSync) {
        timer?.cancel();
        timer = null;
      } else {
        refresh();
      }
    }
  }

  @override
  Balance get balance => _balance ??= getCachedBalance();
  Balance? _balance;

  @override
  Future<Map<String, dynamic>> prepareSend({required String address, required Amount amount, Map<String, dynamic>? args}) async {
    try {
      if (amount.decimals != coin.decimals) {
        throw Exception("Amount decimals do not match coin decimals!");
      }
      var fee = int.parse((await estimateFeeFor(amount, (args!["feeRate"] as FeeRateType).index)).raw.toString());
      Map<String, dynamic> txData = {
        "fee": fee,
        "address": address,
        "recipientAmt": amount,
      };
      return Future.value(txData);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<String> confirmSend({required Map<String, dynamic> txData}) async {
    try {
      final node = getCurrentNode().host + getCurrentNode().port.toString();
      final int amountInMicroTez = ((int.parse((txData["recipientAmt"] as Amount).raw.toString()) * 1000000)).round();
      final int feeInMicroTez = int.parse(txData["fee"].toString());
      final String destinationAddress = txData["address"] as String;
      final String sourceAddress = await currentReceivingAddress;
      return Future.value(""); // TODO: return tx hash
    } catch (e) {
      Logging.instance.log(e.toString(), level: LogLevel.Error);
      return Future.error(e);
    }
  }

  @override
  Future<String> get currentReceivingAddress async {
    var mneString = await mnemonicString;
    if (mneString == null) {
      throw Exception("No mnemonic found!");
    }
    return Future.value((Keystore.fromMnemonic(mneString)).address);
  }

  @override
  Future<Amount> estimateFeeFor(Amount amount, int feeRate) {
    return Future.value(
      Amount(rawValue: BigInt.parse(100000.toString()), fractionDigits: coin.decimals),
    );
  }

  @override
  Future<void> exit() {
    _hasCalledExit = true;
    return Future.value();
  }

  @override
  Future<FeeObject> get fees async {
    // TODO: Change this to get fees from node and fix numberOfBlocks
    return FeeObject(
        numberOfBlocksFast: 1,
        numberOfBlocksAverage: 1,
        numberOfBlocksSlow: 1,
        fast: 1000000,
        medium: 100000,
        slow: 10000,
    );
  }

  @override
  Future<void> fullRescan(int maxUnusedAddressGap, int maxNumberOfIndexesToCheck) {
    refresh();
    return Future.value();
  }

  @override
  Future<bool> generateNewAddress() {
    // TODO: implement generateNewAddress
    throw UnimplementedError();
  }

  @override
  bool get hasCalledExit => _hasCalledExit;
  bool _hasCalledExit = false;

  @override
  Future<void> initializeExisting() async {
    await _prefs.init();
  }

  @override
  Future<void> initializeNew() async {
    var newKeystore = Keystore.random();
    await _secureStore.write(
      key: '${_walletId}_mnemonic',
      value: newKeystore.mnemonic,
    );
    await _secureStore.write(
      key: '${_walletId}_mnemonicPassphrase',
      value: "",
    );

    final address = Address(
        walletId: walletId,
        value: newKeystore.address,
        publicKey: [], // TODO: Add public key
        derivationIndex: 0,
        derivationPath: null,
        type: AddressType.unknown,
        subType: AddressSubType.unknown,
    );

    await db.putAddress(address);

    await Future.wait([
      updateCachedId(walletId),
      updateCachedIsFavorite(false),
    ]);
  }

  @override
  bool get isConnected => _isConnected;
  bool _isConnected = false;

  @override
  bool get isRefreshing => refreshMutex;
  bool refreshMutex = false;

  @override
  // TODO: implement maxFee
  Future<int> get maxFee => throw UnimplementedError();

  @override
  Future<List<String>> get mnemonic async {
    final mnemonic = await mnemonicString;
    final mnemonicPassphrase = await this.mnemonicPassphrase;
    if (mnemonic == null) {
      throw Exception("No mnemonic found!");
    }
    if (mnemonicPassphrase == null) {
      throw Exception("No mnemonic passphrase found!");
    }
    return mnemonic.split(" ");
  }

  @override
  Future<String?> get mnemonicPassphrase => _secureStore.read(key: '${_walletId}_mnemonicPassphrase');

  @override
  Future<String?> get mnemonicString => _secureStore.read(key: '${_walletId}_mnemonic');

  @override
  Future<void> recoverFromMnemonic({required String mnemonic, String? mnemonicPassphrase, required int maxUnusedAddressGap, required int maxNumberOfIndexesToCheck, required int height}) async {
    if ((await mnemonicString) != null ||
        (await this.mnemonicPassphrase) != null) {
      throw Exception("Attempted to overwrite mnemonic on restore!");
    }
    await _secureStore.write(
        key: '${_walletId}_mnemonic', value: mnemonic.trim());
    await _secureStore.write(
      key: '${_walletId}_mnemonicPassphrase',
      value: mnemonicPassphrase ?? "",
    );

    final address = Address(
        walletId: walletId,
        value: Keystore.fromMnemonic(mnemonic).address,
        publicKey: [], // TODO: Add public key
        derivationIndex: 0,
        derivationPath: null,
        type: AddressType.unknown,
        subType: AddressSubType.unknown,
    );

    await db.putAddress(address);

    await Future.wait([
      updateCachedId(walletId),
      updateCachedIsFavorite(false),
    ]);
  }

  Future<void> updateBalance() async {
    var api = "https://api.mainnet.tzkt.io/v1/accounts/${await currentReceivingAddress}/balance"; // TODO: Can we use current node instead of this?
    var theBalance = await get(Uri.parse(api)).then((value) => value.body);
    Logging.instance.log("Balance for ${await currentReceivingAddress}: $theBalance", level: LogLevel.Info);
    var balanceInAmount = Amount(rawValue: BigInt.parse(theBalance.toString()), fractionDigits: 6);
    _balance = Balance(
      total: balanceInAmount,
      spendable: balanceInAmount,
      blockedTotal: Amount(rawValue: BigInt.parse("0"), fractionDigits: 6),
      pendingSpendable: Amount(rawValue: BigInt.parse("0"), fractionDigits: 6),
    );
    await updateCachedBalance(_balance!);
  }

  Future<void> updateTransactions() async {
    var api = "https://api.mainnet.tzkt.io/v1/accounts/${await currentReceivingAddress}/balance_history"; // TODO: Can we use current node instead of this?
    var returnedTxs = await get(Uri.parse(api)).then((value) => value.body);
    Logging.instance.log(
        "Transactions for ${await currentReceivingAddress}: $returnedTxs",
        level: LogLevel.Info);
    List<Tuple2<Transaction, Address>> txs = [];
    Object? jsonTxs = jsonDecode(returnedTxs);
    if (jsonTxs == null) {
      await db.addNewTransactionData(txs, walletId);
    } else {
      for (var tx in jsonTxs as List) {
        var theTx = Transaction(
            walletId: walletId,
            txid: "",
            timestamp: DateTime.parse(tx["timestamp"].toString()).toUtc().millisecondsSinceEpoch ~/ 1000,
            type: TransactionType.unknown,
            subType: TransactionSubType.none,
            amount: int.parse(tx["balance"].toString()),
            amountString: Amount(
                rawValue: BigInt.parse(tx["balance"].toString()),
                fractionDigits: 6
            ).toJsonString(),
            fee: 0,
            height: int.parse(tx["level"].toString()),
            isCancelled: false,
            isLelantus: false,
            slateId: "",
            otherData: "",
            inputs: [],
            outputs: [],
            nonce: 0
        );
        var theAddress = Address(
            walletId: walletId,
            value: await currentReceivingAddress,
            publicKey: [], // TODO: Add public key
            derivationIndex: 0,
            derivationPath: null,
            type: AddressType.unknown,
            subType: AddressSubType.unknown,
        );
        txs.add(Tuple2(theTx, theAddress));
      }
      await db.addNewTransactionData(txs, walletId);
    }
  }

  Future<void> updateChainHeight() async {
    var api = "https://api.tzkt.io/v1/blocks/count"; // TODO: Can we use current node instead of this?
    var returnedHeight = await get(Uri.parse(api)).then((value) => value.body);
    final int intHeight = int.parse(returnedHeight.toString());
    await updateCachedChainHeight(intHeight);
  }

  @override
  Future<void> refresh() {
    updateChainHeight();
    updateBalance();
    updateTransactions();
    return Future.value();
  }

  @override
  int get storedChainHeight => getCachedChainHeight();

  @override
  Future<bool> testNetworkConnection() async{
    try {
      await get(Uri.parse("https://api.mainnet.tzkt.io/v1/accounts/${await currentReceivingAddress}/balance"));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Transaction>> get transactions => db.getTransactions(walletId).findAll();

  @override
  Future<void> updateNode(bool shouldRefresh) async {
    _xtzNode = NodeService(secureStorageInterface: _secureStore).getPrimaryNodeFor(coin: coin) ?? DefaultNodes.getNodeFor(coin);

    if (shouldRefresh) {
      await refresh();
    }
  }

  @override
  Future<void> updateSentCachedTxData(Map<String, dynamic> txData) {
    // TODO: implement updateSentCachedTxData
    throw UnimplementedError();
  }

  @override
  // TODO: implement utxos
  Future<List<UTXO>> get utxos => throw UnimplementedError();

  @override
  bool validateAddress(String address) {
    return RegExp(r"^tz[1-9A-HJ-NP-Za-km-z]{34}$").hasMatch(address);
  }
}
