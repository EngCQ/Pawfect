import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMTokenProvider with ChangeNotifier {
  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  Future<void> initializeFCMToken() async {
    try {
      _fcmToken = await FirebaseMessaging.instance.getToken();
      if (_fcmToken != null) {
        print("FCM Token: $_fcmToken");
        notifyListeners();
      } else {
        print("FCM Token is null");
      }
    } catch (e) {
      print("Error getting FCM token: $e");
    }
  }
}
