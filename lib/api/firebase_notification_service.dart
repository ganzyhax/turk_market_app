import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkmarket_app/api/firebase_notification.dart';
import 'package:turkmarket_app/gateway/gateway.dart';

class FirebaseNotificationService {
  Future<void> load() async {
    late final FirebaseMessaging _messaging;
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String token = await getToken();
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    LocalNotificationService.initialize();
  }

  Future<String> getToken() async {
    try {
      var token = await FirebaseMessaging.instance.getToken();
      String tokenFCM = token.toString();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String localToken = await prefs.getString('token') ?? '';

      if (localToken == '') {
        await FirestoreService()
            .addDocumentToFirestoreWithId('tokens', {'token': tokenFCM});
        await prefs.setString('token', tokenFCM);
      }
      return tokenFCM;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> backgroundHandler(RemoteMessage message) async {
    print(message.toString());
  }
}
