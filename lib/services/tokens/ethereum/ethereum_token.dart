import 'dart:convert';
import 'dart:math';
import 'package:devicelocale/devicelocale.dart';
import 'package:http/http.dart';
import 'package:decimal/decimal.dart';
import 'package:stackwallet/utilities/eth_commons.dart';
import 'package:ethereum_addresses/ethereum_addresses.dart';
import 'package:stackwallet/models/paymint/fee_object_model.dart';
import 'package:stackwallet/models/paymint/transactions_model.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/flutter_secure_storage_interface.dart';
import 'package:stackwallet/services/transaction_notification_tracker.dart';
import 'package:stackwallet/services/tokens/token_service.dart';
import 'package:stackwallet/utilities/format.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/fee_rate_type_enum.dart';
import 'package:stackwallet/models/paymint/transactions_model.dart' as models;
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/web3dart.dart' as transaction;

import 'package:stackwallet/models/node_model.dart';
import 'package:stackwallet/utilities/default_nodes.dart';
import 'package:stackwallet/services/node_service.dart';

class AbiRequestResponse {
  final String message;
  final String result;
  final String status;

  const AbiRequestResponse({
    required this.message,
    required this.result,
    required this.status,
  });

  factory AbiRequestResponse.fromJson(Map<String, dynamic> json) {
    return AbiRequestResponse(
      message: json['message'] as String,
      result: json['result'] as String,
      status: json['status'] as String,
    );
  }
}

const int MINIMUM_CONFIRMATIONS = 3;

class EthereumToken extends TokenServiceAPI {
  @override
  late bool shouldAutoSync;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _credentials;
  late DeployedContract _contract;
  late Map<dynamic, dynamic> _tokenData;
  late ContractFunction _balanceFunction;
  late ContractFunction _sendFunction;
  late Future<List<String>> _walletMnemonic;
  late SecureStorageInterface _secureStore;
  late String _tokenAbi;
  late Web3Client _client;
  late final TransactionNotificationTracker txTracker;
  TransactionData? cachedTxData;

  final _gasLimit = 200000;

  EthereumToken({
    required Map<dynamic, dynamic> tokenData,
    required Future<List<String>> walletMnemonic,
    required SecureStorageInterface secureStore,
  }) {
    _contractAddress =
        EthereumAddress.fromHex(tokenData["contractAddress"] as String);
    _walletMnemonic = walletMnemonic;
    _tokenData = tokenData;
    _secureStore = secureStore;
  }

  Future<AbiRequestResponse> fetchTokenAbi() async {
    final response = await get(Uri.parse(
        "$abiUrl?module=contract&action=getabi&address=$_contractAddress&apikey=EG6J7RJIQVSTP2BS59D3TY2G55YHS5F2HP"));
    if (response.statusCode == 200) {
      return AbiRequestResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load token abi');
    }
  }

  @override
  Future<List<String>> get allOwnAddresses =>
      _allOwnAddresses ??= _fetchAllOwnAddresses();
  Future<List<String>>? _allOwnAddresses;

  Future<List<String>> _fetchAllOwnAddresses() async {
    List<String> addresses = [];
    final ownAddress = _credentials.address;
    addresses.add(ownAddress.toString());
    return addresses;
  }

  @override
  Future<Decimal> get availableBalance async {
    return await totalBalance;
  }

  @override
  Coin get coin => Coin.ethereum;

  @override
  Future<String> confirmSend({required Map<String, dynamic> txData}) async {
    final amount = txData['recipientAmt'];
    final decimalAmount =
        Format.satoshisToAmount(amount as int, coin: Coin.ethereum);
    final bigIntAmount = amountToBigInt(
        decimalAmount.toDouble(), int.parse(_tokenData["decimals"] as String));

    final sentTx = await _client.sendTransaction(
        _credentials,
        transaction.Transaction.callContract(
            contract: _contract,
            function: _sendFunction,
            parameters: [
              EthereumAddress.fromHex(txData['address'] as String),
              bigIntAmount
            ],
            maxGas: _gasLimit,
            gasPrice: EtherAmount.fromUnitAndValue(
                EtherUnit.wei, txData['feeInWei'])));

    return sentTx;
  }

  @override
  Future<String> get currentReceivingAddress async {
    final _currentReceivingAddress = await _credentials.extractAddress();
    final checkSumAddress =
        checksumEthereumAddress(_currentReceivingAddress.toString());
    return checkSumAddress;
  }

  @override
  Future<int> estimateFeeFor(int satoshiAmount, int feeRate) async {
    final fee = estimateFee(
        feeRate, _gasLimit, int.parse(_tokenData["decimals"] as String));
    return Format.decimalAmountToSatoshis(Decimal.parse(fee.toString()), coin);
  }

  @override
  Future<FeeObject> get fees => _feeObject ??= _getFees();
  Future<FeeObject>? _feeObject;

  Future<FeeObject> _getFees() async {
    return await getFees();
  }

  @override
  Future<void> initializeExisting() async {
    if ((await _secureStore.read(
            key: '${_contractAddress.toString()}_tokenAbi')) !=
        null) {
      _tokenAbi = (await _secureStore.read(
          key: '${_contractAddress.toString()}_tokenAbi'))!;
    } else {
      AbiRequestResponse abi = await fetchTokenAbi();
      //Fetch token ABI so we can call token functions
      if (abi.message == "OK") {
        _tokenAbi = abi.result;
        //Store abi in secure store
        await _secureStore.write(
            key: '${_contractAddress.toString()}_tokenAbi', value: _tokenAbi);
      } else {
        throw Exception('Failed to load token abi');
      }
    }

    final mnemonic = await _walletMnemonic;
    String mnemonicString = mnemonic.join(' ');

    //Get private key for given mnemonic
    String privateKey = getPrivateKey(mnemonicString);
    _credentials = EthPrivateKey.fromHex(privateKey);

    _contract = DeployedContract(
        ContractAbi.fromJson(_tokenAbi, _tokenData["name"] as String),
        _contractAddress);
    _balanceFunction = _contract.function('balanceOf');
    _sendFunction = _contract.function('transfer');
    _client = await getEthClient();
  }

  @override
  Future<void> initializeNew() async {
    AbiRequestResponse abi = await fetchTokenAbi();
    //Fetch token ABI so we can call token functions
    if (abi.message == "OK") {
      _tokenAbi = abi.result;
      //Store abi in secure store
      await _secureStore.write(
          key: '${_contractAddress.toString()}_tokenAbi', value: _tokenAbi);
    } else {
      throw Exception('Failed to load token abi');
    }

    final mnemonic = await _walletMnemonic;
    String mnemonicString = mnemonic.join(' ');

    //Get private key for given mnemonic
    String privateKey = getPrivateKey(mnemonicString);
    _credentials = EthPrivateKey.fromHex(privateKey);

    _contract = DeployedContract(
        ContractAbi.fromJson(_tokenAbi, _tokenData["name"] as String),
        _contractAddress);
    _balanceFunction = _contract.function('balanceOf');
    _sendFunction = _contract.function('transfer');
    _client = await getEthClient();
  }

  @override
  // TODO: implement isRefreshing
  bool get isRefreshing => throw UnimplementedError();

  @override
  Future<int> get maxFee async {
    final fee = (await fees).fast;
    final feeEstimate = await estimateFeeFor(0, fee);
    return feeEstimate;
  }

  @override
  Future<Map<String, dynamic>> prepareSend(
      {required String address,
      required int satoshiAmount,
      Map<String, dynamic>? args}) async {
    final feeRateType = args?["feeRate"];
    int fee = 0;
    final feeObject = await fees;
    switch (feeRateType) {
      case FeeRateType.fast:
        fee = feeObject.fast;
        break;
      case FeeRateType.average:
        fee = feeObject.medium;
        break;
      case FeeRateType.slow:
        fee = feeObject.slow;
        break;
    }

    final feeEstimate = await estimateFeeFor(satoshiAmount, fee);

    bool isSendAll = false;
    final balance =
        Format.decimalAmountToSatoshis(await availableBalance, coin);
    if (satoshiAmount == balance) {
      isSendAll = true;
    }

    if (isSendAll) {
      //Send the full balance
      satoshiAmount = balance;
    }

    Map<String, dynamic> txData = {
      "fee": feeEstimate,
      "feeInWei": fee,
      "address": address,
      "recipientAmt": satoshiAmount,
    };

    return txData;
  }

  @override
  Future<void> refresh() {
    // TODO: implement refresh
    throw UnimplementedError();
  }

  @override
  Future<Decimal> get totalBalance async {
    final balanceRequest = await _client.call(
        contract: _contract,
        function: _balanceFunction,
        params: [_credentials.address]);

    String balance = balanceRequest.first.toString();
    int tokenDecimals = int.parse(_tokenData["decimals"] as String);
    final balanceInDecimal = (int.parse(balance) / (pow(10, tokenDecimals)));
    return Decimal.parse(balanceInDecimal.toString());
  }

  @override
  Future<TransactionData> get transactionData =>
      _transactionData ??= _fetchTransactionData();
  Future<TransactionData>? _transactionData;

  @override
  Future<void> updateSentCachedTxData(Map<String, dynamic> txData) async {
    Decimal currentPrice = Decimal.zero;
    final locale = await Devicelocale.currentLocale;
    final String worthNow = Format.localizedStringAsFixed(
        value:
            ((currentPrice * Decimal.fromInt(txData["recipientAmt"] as int)) /
                    Decimal.fromInt(Constants.satsPerCoin(coin)))
                .toDecimal(scaleOnInfinitePrecision: 2),
        decimalPlaces: 2,
        locale: locale!);

    final tx = models.Transaction(
      txid: txData["txid"] as String,
      confirmedStatus: false,
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      txType: "Sent",
      amount: txData["recipientAmt"] as int,
      worthNow: worthNow,
      worthAtBlockTimestamp: worthNow,
      fees: txData["fee"] as int,
      inputSize: 0,
      outputSize: 0,
      inputs: [],
      outputs: [],
      address: txData["address"] as String,
      height: -1,
      confirmations: 0,
    );

    if (cachedTxData == null) {
      final data = await _fetchTransactionData();
      _transactionData = Future(() => data);
    } else {
      final transactions = cachedTxData!.getAllTransactions();
      transactions[tx.txid] = tx;
      cachedTxData = models.TransactionData.fromMap(transactions);
      _transactionData = Future(() => cachedTxData!);
    }
  }

  Future<TransactionData> _fetchTransactionData() async {
    String thisAddress = await currentReceivingAddress;
    // final cachedTransactions = {} as TransactionData?;
    int latestTxnBlockHeight = 0;

    // final priceData =
    //     await _priceAPI.getPricesAnd24hChange(baseCurrency: _prefs.currency);
    Decimal currentPrice = Decimal.zero;
    final List<Map<String, dynamic>> midSortedArray = [];

    AddressTransaction txs =
        await fetchAddressTransactions(thisAddress, "tokentx");

    if (txs.message == "OK") {
      final allTxs = txs.result;
      allTxs.forEach((element) {
        Map<String, dynamic> midSortedTx = {};
        // create final tx map
        midSortedTx["txid"] = element["hash"];
        int confirmations = int.parse(element['confirmations'].toString());

        int transactionAmount = int.parse(element['value'].toString());
        int decimal = int.parse(
            _tokenData["decimals"] as String); //Eth has up to 18 decimal places
        final transactionAmountInDecimal =
            transactionAmount / (pow(10, decimal));

        //Convert to satoshi, default display for other coins
        final satAmount = Format.decimalAmountToSatoshis(
            Decimal.parse(transactionAmountInDecimal.toString()), coin);

        midSortedTx["confirmed_status"] =
            (confirmations != 0) && (confirmations >= MINIMUM_CONFIRMATIONS);
        midSortedTx["confirmations"] = confirmations;
        midSortedTx["timestamp"] = element["timeStamp"];

        if (checksumEthereumAddress(element["from"].toString()) ==
            thisAddress) {
          midSortedTx["txType"] = "Sent";
        } else {
          midSortedTx["txType"] = "Received";
        }

        midSortedTx["amount"] = satAmount;
        final String worthNow = ((currentPrice * Decimal.fromInt(satAmount)) /
                Decimal.fromInt(Constants.satsPerCoin(coin)))
            .toDecimal(scaleOnInfinitePrecision: 2)
            .toStringAsFixed(2);

        //Calculate fees (GasLimit * gasPrice)
        int txFee = int.parse(element['gasPrice'].toString()) *
            int.parse(element['gasUsed'].toString());
        final txFeeDecimal = txFee / (pow(10, decimal));

        midSortedTx["worthNow"] = worthNow;
        midSortedTx["worthAtBlockTimestamp"] = worthNow;
        midSortedTx["aliens"] = <dynamic>[];
        midSortedTx["fees"] = Format.decimalAmountToSatoshis(
            Decimal.parse(txFeeDecimal.toString()), coin);
        midSortedTx["address"] = element["to"];
        midSortedTx["inputSize"] = 1;
        midSortedTx["outputSize"] = 1;
        midSortedTx["inputs"] = <dynamic>[];
        midSortedTx["outputs"] = <dynamic>[];
        midSortedTx["height"] = int.parse(element['blockNumber'].toString());

        midSortedArray.add(midSortedTx);
      });
    }

    midSortedArray.sort((a, b) =>
        (int.parse(b['timestamp'].toString())) -
        (int.parse(a['timestamp'].toString())));

    // buildDateTimeChunks
    final Map<String, dynamic> result = {"dateTimeChunks": <dynamic>[]};
    final dateArray = <dynamic>[];

    for (int i = 0; i < midSortedArray.length; i++) {
      final txObject = midSortedArray[i];
      final date =
          extractDateFromTimestamp(int.parse(txObject['timestamp'].toString()));
      final txTimeArray = [txObject["timestamp"], date];

      if (dateArray.contains(txTimeArray[1])) {
        result["dateTimeChunks"].forEach((dynamic chunk) {
          if (extractDateFromTimestamp(
                  int.parse(chunk['timestamp'].toString())) ==
              txTimeArray[1]) {
            if (chunk["transactions"] == null) {
              chunk["transactions"] = <Map<String, dynamic>>[];
            }
            chunk["transactions"].add(txObject);
          }
        });
      } else {
        dateArray.add(txTimeArray[1]);
        final chunk = {
          "timestamp": txTimeArray[0],
          "transactions": [txObject],
        };
        result["dateTimeChunks"].add(chunk);
      }
    }

    // final transactionsMap = {} as Map<String, models.Transaction>;
    // transactionsMap
    //     .addAll(TransactionData.fromJson(result).getAllTransactions());
    final txModel = TransactionData.fromMap(
        TransactionData.fromJson(result).getAllTransactions());

    cachedTxData = txModel;
    return txModel;
  }

  @override
  bool validateAddress(String address) {
    return isValidEthereumAddress(address);
  }

  Future<NodeModel> getCurrentNode() async {
    return NodeService(secureStorageInterface: _secureStore)
            .getPrimaryNodeFor(coin: coin) ??
        DefaultNodes.getNodeFor(coin);
  }

  Future<Web3Client> getEthClient() async {
    final node = await getCurrentNode();
    return Web3Client(node.host, Client());
  }
}
