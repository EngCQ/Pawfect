import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_assignment/viewmodels/admin/booking_management/admin_add_booking_viewmodel.dart';
import 'package:flutter_assignment/viewmodels/admin/dashboard_viewmodel.dart';
import 'package:flutter_assignment/viewmodels/admin/feedback_management/admin_feedback_viewmodel.dart';
import 'package:provider/provider.dart';
import 'viewmodels/user_authentication.dart';
import 'viewmodels/theme_provider.dart';
import 'routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserAuthentication()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentViewModel()),
        ChangeNotifierProvider(create: (_) => FeedbackViewModel()),
        ChangeNotifierProvider(create: (_) => AdminDashboardViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await _requestNotificationPermission();
    await _getToken();
    _configureFirebaseListeners();
  }

  Future<void> _requestNotificationPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> _getToken() async {
    try {
      String? fcmToken = await _firebaseMessaging.getToken();
      print("FCM Token: $fcmToken");
    } catch (e) {
      print("Error getting FCM token: $e");
    }
  }

  void _configureFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // Display notification
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Handle notification tap
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final userAuth = Provider.of<UserAuthentication>(context, listen: false);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Update isOnline status to false and set lastSeen to the current timestamp when the app is paused or detached
      userAuth.updateOnlineStatus(false, FieldValue.serverTimestamp());
    } else if (state == AppLifecycleState.resumed) {
      // Update isOnline status to true when the app is resumed
      userAuth.updateOnlineStatus(true, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Pet Application',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: AppRoutes.splashScreen,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
