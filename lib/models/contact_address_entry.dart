/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:convert';

import 'package:stackwallet/supported_coins.dart';
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart';

@Deprecated("Use lib/models/isar/models/contact_entry.dart instead")
class ContactAddressEntry {
  final CryptoCurrency coin;
  final String address;
  final String label;
  final String? other;

  const ContactAddressEntry({
    required this.coin,
    required this.address,
    required this.label,
    this.other,
  });

  ContactAddressEntry copyWith({
    CryptoCurrency? coin,
    String? address,
    String? label,
    String? other,
  }) {
    return ContactAddressEntry(
      coin: coin ?? this.coin,
      address: address ?? this.address,
      label: label ?? this.label,
      other: other ?? this.other,
    );
  }

  factory ContactAddressEntry.fromJson(Map<String, dynamic> jsonObject) {
    return ContactAddressEntry(
      coin: SupportedCoins.getCryptoCurrencyFor(jsonObject["coin"] as String),
      address: jsonObject["address"] as String,
      label: jsonObject["label"] as String,
      other: jsonObject["other"] as String?,
    );
  }

  Map<String, String> toMap() {
    return {
      "label": label,
      "address": address,
      "coin": coin.identifier,
      "other": other ?? "",
    };
  }

  String toJsonString() {
    return jsonEncode(toMap());
  }

  @override
  String toString() {
    return "AddressBookEntry: ${toJsonString()}";
  }
}
