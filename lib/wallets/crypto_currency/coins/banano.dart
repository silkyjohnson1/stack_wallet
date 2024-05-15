import 'package:nanodart/nanodart.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/address.dart';
import 'package:stackwallet/models/node_model.dart';
import 'package:stackwallet/utilities/default_nodes.dart';
import 'package:stackwallet/utilities/enums/derive_path_type_enum.dart';
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart';
import 'package:stackwallet/wallets/crypto_currency/intermediate/nano_currency.dart';

class Banano extends NanoCurrency {
  Banano(super.network) {
    switch (network) {
      case CryptoCurrencyNetwork.main:
        _id = "banano";
        _idMain = "banano";
        _name = "Banano";
        _uriScheme = "ban";
        _ticker = "BAN";
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
  int get fractionDigits => 29;

  @override
  BigInt get satsPerCoin => BigInt.parse(
        "100000000000000000000000000000",
      ); // 1*10^29

  @override
  int get minConfirms => 1;

  @override
  AddressType get primaryAddressType => AddressType.banano;

  @override
  String get defaultRepresentative =>
      "ban_1ka1ium4pfue3uxtntqsrib8mumxgazsjf58gidh1xeo5te3whsq8z476goo";

  @override
  int get nanoAccountType => NanoAccountType.BANANO;

  @override
  NodeModel get defaultNode {
    switch (network) {
      case CryptoCurrencyNetwork.main:
        return NodeModel(
          host: "https://kaliumapi.appditto.com/api",
          port: 443,
          name: DefaultNodes.defaultName,
          id: DefaultNodes.buildId(this),
          useSSL: true,
          enabled: true,
          coinName: identifier,
          isFailover: true,
          isDown: false,
        );

      default:
        throw UnimplementedError();
    }
  }

  @override
  Uri defaultBlockExplorer(String txid) {
    switch (network) {
      case CryptoCurrencyNetwork.main:
        return Uri.parse("https://www.bananolooker.com/block/$txid");
      default:
        throw Exception(
          "Unsupported network for defaultBlockExplorer(): $network",
        );
    }
  }

  @override
  DerivePathType get primaryDerivePathType => throw UnsupportedError(
        "$runtimeType does not use bitcoin style derivation paths",
      );
}
