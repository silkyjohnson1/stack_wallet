/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

class PaynymFollow {
  final String follower;
  final String following;
  final String token;

  PaynymFollow(this.follower, this.following, this.token);

  PaynymFollow.fromMap(Map<String, dynamic> map)
      : follower = map["follower"] as String,
        following = map["following"] as String,
        token = map["token"] as String;

  Map<String, dynamic> toMap() => {
        "follower": follower,
        "following": following,
        "token": token,
      };

  @override
  String toString() {
    return toMap().toString();
  }
}
