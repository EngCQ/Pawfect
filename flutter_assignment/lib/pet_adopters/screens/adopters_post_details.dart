import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_back_header.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_navigation_bar.dart';

class AdoptersPostDetails extends StatelessWidget {
  const AdoptersPostDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackHeader(),
      body: SizedBox(
        height: 300,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/pet_adopters/images/pets.jpeg'),
                  fit: BoxFit.contain, // Adjust the fit based on your needs
                ),
              ),
            )
          ],
        ),
      ),
      // bottomNavigationBar: AdoptersNavigationBar(),
    );
  }
}
