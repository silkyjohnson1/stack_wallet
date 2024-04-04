/*
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stackwallet/models/notification_model.dart';
import 'package:stackwallet/services/notifications_service.dart';
import 'package:stackwallet/utilities/prefs.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'channel description',
          // importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker'),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );
  }

  static Future<void> init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('app_icon_alpha');
    const iOS = DarwinInitializationSettings();
    const linux = LinuxInitializationSettings(
        defaultActionName: "temporary_stack_wallet");
    const macOS = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: android,
      iOS: iOS,
      linux: linux,
      macOS: macOS,
    );
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) async {
        onNotifications.add(payload.payload);
      },
      onDidReceiveBackgroundNotificationResponse: (payload) async {
        onNotifications.add(payload.payload);
      },
    );
  }

  static Future<void> clearNotifications() async => _notifications.cancelAll();

  static Future<void> clearNotification(int id) async =>
      _notifications.cancel(id);

  //===================================
  static late Prefs prefs;
  static late NotificationsService notificationsService;

  static Future<void> showNotification({
    required String title,
    required String body,
    required String walletId,
    required String iconAssetName,
    required DateTime date,
    required bool shouldWatchForUpdates,
    required String coinName,
    String? txid,
    int? confirmations,
    int? requiredConfirmations,
    String? changeNowId,
    String? payload,
  }) async {
    await prefs.incrementCurrentNotificationIndex();
    final id = prefs.currentNotificationId;

    String confirms = "";
    if (txid != null &&
        confirmations != null &&
        requiredConfirmations != null) {
      confirms = " ($confirmations/$requiredConfirmations)";
    }

    final NotificationModel model = NotificationModel(
      id: id,
      title: title + confirms,
      description: body,
      iconAssetName: iconAssetName,
      date: date,
      walletId: walletId,
      read: false,
      shouldWatchForUpdates: shouldWatchForUpdates,
      coinName: coinName,
      txid: txid,
      changeNowId: changeNowId,
    );

    await Future.wait([
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      ),
      notificationsService.add(model, true),
    ]);
  }
}
