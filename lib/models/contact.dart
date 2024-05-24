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

import 'contact_address_entry.dart';
import 'package:uuid/uuid.dart';

@Deprecated("Use lib/models/isar/models/contact_entry.dart instead")
class Contact {
  final String? emojiChar;
  final String name;
  final List<ContactAddressEntry> addresses;
  final bool isFavorite;

  String get id => _id;
  late String _id;

  Contact({
    this.emojiChar,
    required this.name,
    required this.addresses,
    required this.isFavorite,
    String? id,
  }) {
    if (id != null) {
      _id = id;
    } else {
      _id = const Uuid().v1();
    }
  }

  Contact copyWith({
    bool shouldCopyEmojiWithNull = false,
    String? emojiChar,
    String? name,
    List<ContactAddressEntry>? addresses,
    bool? isFavorite,
  }) {
    List<ContactAddressEntry> _addresses = [];
    if (addresses == null) {
      for (var e in this.addresses) {
        _addresses.add(e.copyWith());
      }
    } else {
      for (var e in addresses) {
        _addresses.add(e.copyWith());
      }
    }
    String? newEmoji;
    if (shouldCopyEmojiWithNull) {
      newEmoji = emojiChar;
    } else {
      newEmoji = emojiChar ?? this.emojiChar;
    }

    return Contact(
      emojiChar: newEmoji,
      name: name ?? this.name,
      addresses: _addresses,
      isFavorite: isFavorite ?? this.isFavorite,
      id: id,
    );
  }

  factory Contact.fromJson(Map<String, dynamic> jsonObject) {
    return Contact(
      emojiChar: jsonObject["emoji"] as String?,
      name: jsonObject["name"] as String,
      addresses: List<ContactAddressEntry>.from(
        (jsonObject["addresses"] as List).map(
          (e) => ContactAddressEntry.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        ),
      ),
      id: jsonObject["id"] as String,
      isFavorite: jsonObject["isFavorite"] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "emoji": emojiChar,
      "name": name,
      "addresses": addresses.map((e) => e.toMap()).toList(),
      "id": id,
      "isFavorite": isFavorite,
    };
  }

  String toJsonString() {
    return jsonEncode(toMap());
  }

  @override
  String toString() {
    return "Contact: ${toJsonString()}";
  }
}
