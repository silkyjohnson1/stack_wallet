/// address : "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984"
/// blockNumber : 16484149
/// logIndex : 61
/// topics : ["0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef","0x0000000000000000000000003a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597","0x000000000000000000000000c5e81fc2401b8104966637d5334cbce92f01dbf7"]
/// data : "0x0000000000000000000000000000000000000000000000002dac1c4be587d800"
/// articulatedLog : {"name":"Transfer","inputs":{"_amount":"3291036540000000000","_from":"0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597","_to":"0xc5e81fc2401b8104966637d5334cbce92f01dbf7"}}
/// compressedLog : "{name:Transfer|inputs:{_amount:3291036540000000000|_from:0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597|_to:0xc5e81fc2401b8104966637d5334cbce92f01dbf7}}"
/// transactionHash : "0x5b59559a77fa5f1c70528d41f4fa2e5fa5a00b21fc2f3bc26b208b3062e46333"
/// transactionIndex : 25

class EthTokenTxDto {
  EthTokenTxDto({
    required this.address,
    required this.blockNumber,
    required this.logIndex,
    required this.topics,
    required this.data,
    required this.articulatedLog,
    required this.compressedLog,
    required this.transactionHash,
    required this.transactionIndex,
  });

  EthTokenTxDto.fromMap(Map<String, dynamic> map)
      : address = map['address'] as String,
        blockNumber = map['blockNumber'] as int,
        logIndex = map['logIndex'] as int,
        topics = List<String>.from(map['topics'] as List),
        data = map['data'] as String,
        articulatedLog = map['articulatedLog'] == null
            ? null
            : ArticulatedLog.fromMap(
                Map<String, dynamic>.from(
                  map['articulatedLog'] as Map,
                ),
              ),
        compressedLog = map['compressedLog'] as String,
        transactionHash = map['transactionHash'] as String,
        transactionIndex = map['transactionIndex'] as int;

  final String address;
  final int blockNumber;
  final int logIndex;
  final List<String> topics;
  final String data;
  final ArticulatedLog? articulatedLog;
  final String compressedLog;
  final String transactionHash;
  final int transactionIndex;

  EthTokenTxDto copyWith({
    String? address,
    int? blockNumber,
    int? logIndex,
    List<String>? topics,
    String? data,
    ArticulatedLog? articulatedLog,
    String? compressedLog,
    String? transactionHash,
    int? transactionIndex,
  }) =>
      EthTokenTxDto(
        address: address ?? this.address,
        blockNumber: blockNumber ?? this.blockNumber,
        logIndex: logIndex ?? this.logIndex,
        topics: topics ?? this.topics,
        data: data ?? this.data,
        articulatedLog: articulatedLog ?? this.articulatedLog,
        compressedLog: compressedLog ?? this.compressedLog,
        transactionHash: transactionHash ?? this.transactionHash,
        transactionIndex: transactionIndex ?? this.transactionIndex,
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['address'] = address;
    map['blockNumber'] = blockNumber;
    map['logIndex'] = logIndex;
    map['topics'] = topics;
    map['data'] = data;
    map['articulatedLog'] = articulatedLog?.toMap();
    map['compressedLog'] = compressedLog;
    map['transactionHash'] = transactionHash;
    map['transactionIndex'] = transactionIndex;
    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

/// name : "Transfer"
/// inputs : {"_amount":"3291036540000000000","_from":"0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597","_to":"0xc5e81fc2401b8104966637d5334cbce92f01dbf7"}

class ArticulatedLog {
  ArticulatedLog({
    required this.name,
    required this.inputs,
  });

  ArticulatedLog.fromMap(Map<String, dynamic> map)
      : name = map['name'] as String,
        inputs = Inputs.fromMap(
          Map<String, dynamic>.from(
            map['inputs'] as Map,
          ),
        );

  final String name;
  final Inputs inputs;

  ArticulatedLog copyWith({
    String? name,
    Inputs? inputs,
  }) =>
      ArticulatedLog(
        name: name ?? this.name,
        inputs: inputs ?? this.inputs,
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['inputs'] = inputs.toMap();
    return map;
  }
}

/// _amount : "3291036540000000000"
/// _from : "0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597"
/// _to : "0xc5e81fc2401b8104966637d5334cbce92f01dbf7"
///
class Inputs {
  Inputs({
    required this.amount,
    required this.from,
    required this.to,
  });

  Inputs.fromMap(Map<String, dynamic> map)
      : amount = map['_amount'] as String,
        from = map['_from'] as String,
        to = map['_to'] as String;

  final String amount;
  final String from;
  final String to;

  Inputs copyWith({
    String? amount,
    String? from,
    String? to,
  }) =>
      Inputs(
        amount: amount ?? this.amount,
        from: from ?? this.from,
        to: to ?? this.to,
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['_amount'] = amount;
    map['_from'] = from;
    map['_to'] = to;
    return map;
  }
}
