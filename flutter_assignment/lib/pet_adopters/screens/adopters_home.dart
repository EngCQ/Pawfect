import 'package:flutter/material.dart';
import 'package:flutter_assignment/pet_adopters/design/default_header.dart';
import 'package:flutter_assignment/pet_adopters/design/navigation_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DefaultHeader(),
      bottomNavigationBar: AdopterNavigationBar(),
    );
  }
}
