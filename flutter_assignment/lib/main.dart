// // lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'providers/theme_provider.dart';
// import 'providers/user_provider.dart'; // Import the UserProvider
// import 'routes.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//         ChangeNotifierProvider(create: (_) => UserProvider()), // Add UserProvider
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return MaterialApp(
//       title: 'Pet Application',
//       themeMode: themeProvider.themeMode,
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       initialRoute: AppRoutes.splashScreen,
//       onGenerateRoute: AppRoutes.generateRoute,
//     );
//   }
// }

import "package:flutter/material.dart";
import "package:flutter_assignment/screens/adopter/adding_testing_data.dart";
import "package:flutter_assignment/screens/adopter/adopters_appointment.dart";
import "package:flutter_assignment/screens/adopter/adopters_favourite.dart";
import "package:flutter_assignment/screens/adopter/adopters_filter.dart";
import "package:flutter_assignment/screens/adopter/adopters_home.dart";
import "package:flutter_assignment/screens/adopter/adopters_notification.dart";
import "package:flutter_assignment/screens/adopter/adopters_post_details.dart";
import "package:flutter_assignment/screens/adopter/adopters_profile.dart";
import "package:flutter_assignment/screens/adopter/getting_testing_data.dart";
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  runApp(const MyApp());

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => AdoptersHome(),
        '/favourites': (context) => AdoptersFavourite(),
        '/post_details': (context) => const AdoptersPostDetails(),
        '/appointments': (context) => AdoptersAppointment(),
        '/chat': (context) => const AddingTestingData(),
        '/profile': (context) => AdoptersProfile(),
        '/filter': (context) => const AdoptersFilter(),
        '/notification': (context) => AdoptersNotification(),
      },
    );
  }
}
