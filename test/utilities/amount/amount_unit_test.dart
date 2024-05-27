import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/utilities/amount/amount_unit.dart';
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart';

void main() {
  test("displayAmount BTC", () {
    final Amount amount = Amount(
      rawValue: BigInt.from(1012345678),
      fractionDigits: 8,
    );

    expect(
      AmountUnit.normal.displayAmount(
        amount: amount,
        locale: "en_US",
        coin: Bitcoin(CryptoCurrencyNetwork.main),
        maxDecimalPlaces: 8,
      ),
      "10.12345678 BTC",
    );

    expect(
      AmountUnit.milli.displayAmount(
        amount: amount,
        locale: "en_US",
        coin: Bitcoin(CryptoCurrencyNetwork.main),
        maxDecimalPlaces: 8,
      ),
      "10,123.45678 mBTC",
    );

    expect(
      AmountUnit.micro.displayAmount(
        amount: amount,
        locale: "en_US",
        coin: Bitcoin(CryptoCurrencyNetwork.main),
        maxDecimalPlaces: 8,
      ),
      "10,123,456.78 µBTC",
    );

    expect(
      AmountUnit.nano.displayAmount(
        amount: amount,
        locale: "en_US",
        coin: Bitcoin(CryptoCurrencyNetwork.main),
        maxDecimalPlaces: 8,
      ),
      "1,012,345,678 sats",
    );
    final dec = Decimal.parse("10.123456789123456789");

    expect(dec.toString(), "10.123456789123456789");
  });

  test("displayAmount ETH", () {
    final eth = Ethereum(CryptoCurrencyNetwork.main);

    final Amount amount = Amount.fromDecimal(
      Decimal.parse("10.123456789123456789"),
      fractionDigits: eth.fractionDigits,
    );

    expect(
      AmountUnit.normal.displayAmount(
        amount: amount,
        locale: "en_US",
        coin: eth,
        maxDecimalPlaces: 8,
      ),
      "~10.12345678 ETH",
    );

    expect(
      AmountUnit.normal.displayAmount(
        amount: amount,
        locale: "en_US",
        coin: eth,
        maxDecimalPlaces: 4,
      ),
      "~10.1234 ETH",
    );

    expect(
      AmountUnit.normal.displayAmount(
        amount: amount,
        locale: "en_US",
        coin: eth,
        maxDecimalPlaces: 18,
      ),
      "10.123456789123456789 ETH",
    );

    expect(
      AmountUnit.milli.displayAmount(
        amount: amount,
        locale: "en_US",
        coin: eth,
        maxDecimalPlaces: 9,
      ),
      "~10,123.456789123 mETH",
    );

    expect(
      AmountUnit.micro.displayAmount(
        amount: amount,
        locale: "en_US",
        coin: eth,
        maxDecimalPlaces: 8,
      ),
      "~10,123,456.78912345 µETH",
    );

    expect(
      AmountUnit.nano.displayAmount(
        amount: amount,
        locale: "en_US",
        coin: eth,
        maxDecimalPlaces: 1,
      ),
      "~10,123,456,789.1 gwei",
    );

    expect(
      AmountUnit.pico.displayAmount(
        amount: amount,
        locale: "en_US",
        coin: eth,
        maxDecimalPlaces: 18,
      ),
      "10,123,456,789,123.456789 mwei",
    );

    expect(
      AmountUnit.femto.displayAmount(
        amount: amount,
        locale: "en_US",
        coin: eth,
        maxDecimalPlaces: 4,
      ),
      "10,123,456,789,123,456.789 kwei",
    );

    expect(
      AmountUnit.atto.displayAmount(
        amount: amount,
        locale: "en_US",
        coin: eth,
        maxDecimalPlaces: 1,
      ),
      "10,123,456,789,123,456,789 wei",
    );
  });

  test("parse eth string to amount", () {
    final eth = Ethereum(CryptoCurrencyNetwork.main);
    final Amount amount = Amount.fromDecimal(
      Decimal.parse("10.123456789123456789"),
      fractionDigits: eth.fractionDigits,
    );

    expect(
      AmountUnit.nano.tryParse(
        "~10,123,456,789.1 gwei",
        locale: "en_US",
        coin: eth,
      ),
      Amount.fromDecimal(
        Decimal.parse("10.1234567891"),
        fractionDigits: eth.fractionDigits,
      ),
    );

    expect(
      AmountUnit.atto.tryParse(
        "10,123,456,789,123,456,789 wei",
        locale: "en_US",
        coin: eth,
      ),
      amount,
    );
  });

  test("parse btc string to amount", () {
    final Amount amount = Amount(
      rawValue: BigInt.from(1012345678),
      fractionDigits: 8,
    );

    expect(
      AmountUnit.normal.tryParse(
        "10.12345678 BTC",
        locale: "en_US",
        coin: Bitcoin(CryptoCurrencyNetwork.main),
      ),
      amount,
    );

    expect(
      AmountUnit.milli.tryParse(
        "10,123.45678 mBTC",
        locale: "en_US",
        coin: Bitcoin(CryptoCurrencyNetwork.main),
      ),
      amount,
    );

    expect(
      AmountUnit.micro.tryParse(
        "10,123,456.7822 µBTC",
        locale: "en_US",
        coin: Bitcoin(CryptoCurrencyNetwork.main),
      ),
      amount,
    );

    expect(
      AmountUnit.nano.tryParse(
        "1,012,345,678 sats",
        locale: "en_US",
        coin: Bitcoin(CryptoCurrencyNetwork.main),
      ),
      amount,
    );
  });
}
