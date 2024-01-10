import 'package:isar/isar.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/address.dart';
import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/particl.dart';
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart';
import 'package:stackwallet/wallets/wallet/intermediate/bip39_hd_wallet.dart';
import 'package:stackwallet/wallets/wallet/wallet_mixin_interfaces/coin_control_interface.dart';
import 'package:stackwallet/wallets/wallet/wallet_mixin_interfaces/electrumx_interface.dart';
import 'package:tuple/tuple.dart';

class ParticlWallet extends Bip39HDWallet
    with ElectrumXInterface, CoinControlInterface {
  @override
  int get isarTransactionVersion => 2;

  ParticlWallet(CryptoCurrencyNetwork network) : super(Particl(network));

  // TODO: double check these filter operations are correct and do not require additional parameters
  @override
  FilterOperation? get changeAddressFilterOperation =>
      FilterGroup.and(standardChangeAddressFilters);

  @override
  FilterOperation? get receivingAddressFilterOperation =>
      FilterGroup.and(standardReceivingAddressFilters);

  // ===========================================================================

  @override
  Future<List<Address>> fetchAddressesForElectrumXScan() async {
    final allAddresses = await mainDB
        .getAddresses(walletId)
        .filter()
        .not()
        .group(
          (q) => q
              .typeEqualTo(AddressType.nonWallet)
              .or()
              .subTypeEqualTo(AddressSubType.nonWallet),
        )
        .findAll();
    return allAddresses;
  }

// ===========================================================================

  @override
  Future<({bool blocked, String? blockedReason, String? utxoLabel})>
      checkBlockUTXO(Map<String, dynamic> jsonUTXO, String? scriptPubKeyHex,
          Map<String, dynamic> jsonTX, String? utxoOwnerAddress) async {
    // Particl doesn't have special outputs like tokens, ordinals, etc.
    // But it may have special types of outputs which we shouldn't or can't spend.
    // TODO: [prio=low] Check for special Particl outputs.
    return (blocked: false, blockedReason: null, utxoLabel: null);
  }

  @override
  int estimateTxFee({required int vSize, required int feeRatePerKB}) {
    return vSize * (feeRatePerKB / 1000).ceil();
  }

  @override
  Amount roughFeeEstimate(int inputCount, int outputCount, int feeRatePerKB) {
    return Amount(
      rawValue: BigInt.from(
          ((42 + (272 * inputCount) + (128 * outputCount)) / 4).ceil() *
              (feeRatePerKB / 1000).ceil()),
      fractionDigits: cryptoCurrency.fractionDigits,
    );
  }

  @override
  Future<void> updateTransactions() async {
    final currentChainHeight = await fetchChainHeight();

    // TODO: [prio=high] switch to V2 transactions.
    final data = await fetchTransactionsV1(
      addresses: await fetchAddressesForElectrumXScan(),
      currentChainHeight: currentChainHeight,
    );

    await mainDB.addNewTransactionData(
      data
          .map((e) => Tuple2(
                e.transaction,
                e.address,
              ))
          .toList(),
      walletId,
    );
  }
}
