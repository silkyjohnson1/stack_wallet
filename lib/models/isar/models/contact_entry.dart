/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:isar/isar.dart';
import 'package:stackwallet/supported_coins.dart';
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart';

part 'contact_entry.g.dart';

@collection
class ContactEntry {
  ContactEntry({
    this.emojiChar,
    required this.name,
    required this.addresses,
    required this.isFavorite,
    required this.customId,
  });

  Id id = Isar.autoIncrement;

  late final String? emojiChar;
  late final String name;
  late final List<ContactAddressEntry> addresses;
  late final bool isFavorite;

  @Index(unique: true, replace: true)
  late final String customId;

  @ignore
  List<ContactAddressEntry> get addressesSorted {
    final List<ContactAddressEntry> sorted = [];
    for (final coin in Coins.enabled) {
      final slice = addresses.where((e) => e.coin == coin).toList();
      if (slice.isNotEmpty) {
        slice.sort(
          (a, b) => (a.other ?? a.label).compareTo(b.other ?? b.label),
        );
        sorted.addAll(slice);
      }
    }

    return sorted;
  }

  ContactEntry copyWith({
    bool shouldCopyEmojiWithNull = false,
    String? emojiChar,
    String? name,
    List<ContactAddressEntry>? addresses,
    bool? isFavorite,
  }) {
    final List<ContactAddressEntry> _addresses = [];
    if (addresses == null) {
      for (final e in this.addresses) {
        _addresses.add(e.copyWith());
      }
    } else {
      for (final e in addresses) {
        _addresses.add(e.copyWith());
      }
    }
    String? newEmoji;
    if (shouldCopyEmojiWithNull) {
      newEmoji = emojiChar;
    } else {
      newEmoji = emojiChar ?? this.emojiChar;
    }

    return ContactEntry(
      emojiChar: newEmoji,
      name: name ?? this.name,
      addresses: _addresses,
      isFavorite: isFavorite ?? this.isFavorite,
      customId: customId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "emoji": emojiChar,
      "name": name,
      "addresses": addresses.map((e) => e.toMap()).toList(),
      "id": customId,
      "isFavorite": isFavorite,
    };
  }
}

@embedded
class ContactAddressEntry {
  late final String coinName;
  late final String address;
  late final String label;
  late final String? other;

  @ignore
  CryptoCurrency get coin => Coins.getCryptoCurrencyFor(coinName);

  ContactAddressEntry();

  ContactAddressEntry copyWith({
    CryptoCurrency? coin,
    String? address,
    String? label,
    String? other,
  }) {
    return ContactAddressEntry()
      ..coinName = coin?.identifier ?? coinName
      ..address = address ?? this.address
      ..label = label ?? this.label
      ..other = other ?? this.other;
  }

  Map<String, String> toMap() {
    return {
      "label": label,
      "address": address,
      "coin": coin.identifier,
      "other": other ?? "",
    };
  }

  @override
  String toString() {
    return "AddressBookEntry: ${toMap()}";
  }
}
