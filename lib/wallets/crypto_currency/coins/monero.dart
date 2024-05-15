import 'package:cw_monero/api/wallet.dart' as monero_wallet;
import 'package:stackwallet/models/node_model.dart';
import 'package:stackwallet/utilities/default_nodes.dart';
import 'package:stackwallet/utilities/enums/derive_path_type_enum.dart';
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart';
import 'package:stackwallet/wallets/crypto_currency/intermediate/cryptonote_currency.dart';

class Monero extends CryptonoteCurrency {
  Monero(super.network) {
    _idMain = "monero";
    _uriScheme = "monero";
    switch (network) {
      case CryptoCurrencyNetwork.main:
        _id = _idMain;
        _name = "Monero";
        _ticker = "XMR";
      default:
        throw Exception("Unsupported network: $network");
    }
  }

  late final String _id;
  @override
  String get identifier => _id;

  late final String _idMain;
  @override
  String get mainNetId => _idMain;

  late final String _name;
  @override
  String get prettyName => _name;

  late final String _uriScheme;
  @override
  String get uriScheme => _uriScheme;

  late final String _ticker;
  @override
  String get ticker => _ticker;

  @override
  int get minConfirms => 10;

  @override
  bool validateAddress(String address) {
    return monero_wallet.validateAddress(address);
  }

  @override
  NodeModel get defaultNode {
    switch (network) {
      case CryptoCurrencyNetwork.main:
        return NodeModel(
          host: "https://monero.stackwallet.com",
          port: 18081,
          name: DefaultNodes.defaultName,
          id: DefaultNodes.buildId(this),
          useSSL: true,
          enabled: true,
          coinName: identifier,
          isFailover: true,
          isDown: false,
          trusted: true,
        );

      default:
        throw UnimplementedError();
    }
  }

  @override
  int get defaultSeedPhraseLength => 25;

  @override
  int get fractionDigits => 12;

  @override
  bool get hasBuySupport => false;

  @override
  bool get hasMnemonicPassphraseSupport => false;

  @override
  List<int> get possibleMnemonicLengths => [defaultSeedPhraseLength];

  @override
  BigInt get satsPerCoin => BigInt.from(1000000000000);

  @override
  int get targetBlockTimeSeconds => 120;

  @override
  DerivePathType get primaryDerivePathType => throw UnsupportedError(
        "$runtimeType does not use bitcoin style derivation paths",
      );

  @override
  Uri defaultBlockExplorer(String txid) {
    switch (network) {
      case CryptoCurrencyNetwork.main:
        return Uri.parse("https://xmrchain.net/tx/$txid");
      default:
        throw Exception(
          "Unsupported network for defaultBlockExplorer(): $network",
        );
    }
  }
}
