import 'package:flutter/material.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_default_header.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_navigation_bar.dart';

class AdoptersProfile extends StatelessWidget {
  const AdoptersProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultHeader(),
      body: ListView(
        children: [],
      ),
      bottomNavigationBar: AdoptersNavigationBar(),
    );
  }
}
