import 'package:flutter/material.dart';

class HomePost extends StatelessWidget {
  const HomePost({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 300,
        color: const Color.fromARGB(200, 20, 100, 30),
      ),
    );
  }
}
