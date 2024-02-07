import 'dart:math';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();

  void requestIOSPermissions() {
    //можно удалить, так как запрашиваем в main.dart
    _notificationPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static NotificationDetails? notificationDetails;

  static void initialize() {
    const InitializationSettings initializationSettings =
        const InitializationSettings(
            android: const AndroidInitializationSettings("@mipmap/ic_launcher"),
            iOS: IOSInitializationSettings(
              requestSoundPermission: true,
              requestBadgePermission: true,
              requestAlertPermission: true,
            ));

    notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "turkMarketMobileApp",
          "turkMarketMobileApp_channel",
          "basic channel for notification",
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: IOSNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: "",
            badgeNumber: 0,
            subtitle: "Subtitle",
            threadIdentifier: "threadId"));

    if (Platform.isAndroid) {
      createChannels();
    } else if (Platform.isIOS) {
      //TODO iOS-specific code
    }
    _notificationPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    try {
      final id = Random().nextInt(10000);

      await _notificationPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails);
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}

void createChannels() {
  //Создаем каналы для уведомлений
  AndroidNotificationChannel notificationChannel = AndroidNotificationChannel(
    "turkMarketMobileApp",
    "Канал по умолчанию",
    "Канал по умолчанию",
    importance: Importance.max,
    playSound: true,
  );

  AndroidFlutterLocalNotificationsPlugin
      androidFlutterLocalNotificationsPlugin =
      AndroidFlutterLocalNotificationsPlugin();

  androidFlutterLocalNotificationsPlugin
      .createNotificationChannel(notificationChannel);
}
