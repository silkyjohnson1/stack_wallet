/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */
import '../../../../utilities/logger.dart';

enum TorConnectionStatus { disconnected, connecting, connected }

class TorConnectionStatusChangedEvent {
  TorConnectionStatus newStatus;
  String message = "";

  TorConnectionStatusChangedEvent(this.newStatus, this.message) {
    Logging.instance.log(
      "TorSyncStatusChangedEvent fired with arg newStatus = $newStatus ($message)",
      level: LogLevel.Info,
    );
  }
}
