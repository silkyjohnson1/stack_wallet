import 'package:isar/isar.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/input.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/output.dart';
import 'package:stackwallet/models/isar/models/transaction_note.dart';

part 'transaction.g.dart';

@Collection()
class Transaction {
  Id id = Isar.autoIncrement;

  late String txid;

  late bool confirmed;

  late int confirmations;

  late int timestamp;

  @enumerated
  late TransactionType txType;

  @enumerated
  late TransactionSubType subType;

  late int amount;

  // TODO: do we need this?
  // late List<dynamic> aliens;

  late String worthAtBlockTimestamp;

  late int fee;

  late String address;

  late int height;

  late bool cancelled;

  late String? slateId;

  late String? otherData;

  final inputs = IsarLinks<Input>();

  final outputs = IsarLinks<Output>();

  final note = IsarLink<TransactionNote>();
}

// Used in Isar db and stored there as int indexes so adding/removing values
// in this definition should be done extremely carefully in production
enum TransactionType {
  // TODO: add more types before prod release?
  outgoing,
  incoming,
  sendToSelf, // should we keep this?
  anonymize; // firo specific

}

// Used in Isar db and stored there as int indexes so adding/removing values
// in this definition should be done extremely carefully in production
enum TransactionSubType {
  // TODO: add more types before prod release?
  none,
  bip47Notification, // bip47 payment code notification transaction flag
  mint; // firo specific

}
