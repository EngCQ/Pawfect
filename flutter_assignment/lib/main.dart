import "package:flutter/material.dart";
import "package:flutter_assignment/pet_adopters/screens/adopters_appointment.dart";
import "package:flutter_assignment/pet_adopters/screens/adopters_favourite.dart";
import "package:flutter_assignment/pet_adopters/screens/adopters_home.dart";
import 'package:firebase_core/firebase_core.dart';
import "package:flutter_assignment/pet_adopters/screens/adopters_post_details.dart";
import 'firebase_options.dart';

Future<void> main() async {
  runApp(const MyApp());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      },
    );
  }
}
