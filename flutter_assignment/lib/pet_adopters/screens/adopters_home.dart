import 'package:flutter/material.dart';
import 'package:flutter_assignment/pet_adopters/components/home_post.dart';
import 'package:flutter_assignment/pet_adopters/design/default_header.dart';
import 'package:flutter_assignment/pet_adopters/design/navigation_bar.dart';

class AdoptersHome extends StatelessWidget {
  const AdoptersHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DefaultHeader(),
      body: Column(
        children: [
          HomePost(),
        ],
      ),
      bottomNavigationBar: AdopterNavigationBar(),
    );
  }
}
