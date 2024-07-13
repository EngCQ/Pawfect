// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB9WJTRoHP9xUysjMoXezxq3-UbnwRFUhQ',
    appId: '1:544995057564:web:3d556196a795847136f259',
    messagingSenderId: '544995057564',
    projectId: 'pawfect-3128b',
    authDomain: 'pawfect-3128b.firebaseapp.com',
    storageBucket: 'pawfect-3128b.appspot.com',
    measurementId: 'G-5YLHJ3SP88',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAJKTcUjqzHvP_WqRXoe6ehwuuma3vo14s',
    appId: '1:544995057564:android:66eeed9b2102245f36f259',
    messagingSenderId: '544995057564',
    projectId: 'pawfect-3128b',
    storageBucket: 'pawfect-3128b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtdJLQtREFzq-pZ0fh1lxw0_Znw2jFYew',
    appId: '1:544995057564:ios:9dd6aaa95ce2b4c236f259',
    messagingSenderId: '544995057564',
    projectId: 'pawfect-3128b',
    storageBucket: 'pawfect-3128b.appspot.com',
    iosBundleId: 'com.example.flutterAssignment',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtdJLQtREFzq-pZ0fh1lxw0_Znw2jFYew',
    appId: '1:544995057564:ios:9dd6aaa95ce2b4c236f259',
    messagingSenderId: '544995057564',
    projectId: 'pawfect-3128b',
    storageBucket: 'pawfect-3128b.appspot.com',
    iosBundleId: 'com.example.flutterAssignment',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB9WJTRoHP9xUysjMoXezxq3-UbnwRFUhQ',
    appId: '1:544995057564:web:ee87c3f15f45e36b36f259',
    messagingSenderId: '544995057564',
    projectId: 'pawfect-3128b',
    authDomain: 'pawfect-3128b.firebaseapp.com',
    storageBucket: 'pawfect-3128b.appspot.com',
    measurementId: 'G-T5QRD5BP63',
  );
}
