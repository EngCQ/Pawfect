import "package:flutter/material.dart";
import "package:flutter_assignment/pet_adopters/screens/adopters_favourite.dart";
import "package:flutter_assignment/pet_adopters/screens/adopters_home.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
