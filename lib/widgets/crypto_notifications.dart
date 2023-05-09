import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/services/notifications_api.dart';
import 'package:stackwallet/themes/coin_icon_provider.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';

abstract class CryptoNotificationsEventBus {
  static final instance = EventBus();
}

class CryptoNotificationEvent {
  final String title;
  final String walletId;
  final String walletName;
  final DateTime date;
  final bool shouldWatchForUpdates;
  final Coin coin;
  final String? txid;
  final int? confirmations;
  final int? requiredConfirmations;
  final String? changeNowId;
  final String? payload;

  CryptoNotificationEvent({
    required this.title,
    required this.walletId,
    required this.walletName,
    required this.date,
    required this.shouldWatchForUpdates,
    required this.coin,
    this.txid,
    this.confirmations,
    this.requiredConfirmations,
    this.changeNowId,
    this.payload,
  });
}

class CryptoNotifications extends ConsumerStatefulWidget {
  const CryptoNotifications({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  ConsumerState<CryptoNotifications> createState() =>
      _CryptoNotificationsState();
}

class _CryptoNotificationsState extends ConsumerState<CryptoNotifications> {
  late final StreamSubscription<dynamic>? _streamSubscription;

  Future<void> _showNotification(CryptoNotificationEvent event) async {
    await NotificationApi.showNotification(
      title: event.title,
      body: event.walletName,
      walletId: event.walletId,
      iconAssetName: ref.read(coinIconProvider(event.coin)),
      date: event.date,
      shouldWatchForUpdates: event.shouldWatchForUpdates,
      coinName: event.coin.name,
      txid: event.txid,
      confirmations: event.confirmations,
      requiredConfirmations: event.requiredConfirmations,
      changeNowId: event.changeNowId,
      payload: event.payload,
    );
  }

  @override
  void initState() {
    _streamSubscription = CryptoNotificationsEventBus.instance
        .on<CryptoNotificationEvent>()
        .listen(
      (event) async {
        unawaited(_showNotification(event));
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
