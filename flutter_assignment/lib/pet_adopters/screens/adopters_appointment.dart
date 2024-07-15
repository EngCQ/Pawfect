import 'package:flutter/material.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_default_header.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_navigation_bar.dart';

class AdoptersAppointment extends StatelessWidget {
  AdoptersAppointment({super.key});

  // List of all post details
  final List<String> appointmentName = [
    'post 1',
    'post 2',
    'post 3',
  ];

  final List<String> appointmenImage = [
    'lib/pet_adopters/images/pets.jpeg',
    'lib/pet_adopters/images/pets.jpeg',
    'lib/pet_adopters/images/pets.jpeg',
  ];

  final List<String> appointmentPetName = [
    'Teddy',
    'Jakie',
    'Joy',
  ];

  final List<String> appointmentType = [
    'Missing Pet',
    'Pet Adoption',
    'Pet Adoption',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultHeader(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your Booking',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: appointmentName.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(appointmenImage[index]),
                  title: Text(appointmentName[index]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pet Name: ${appointmentPetName[index]}'),
                      Text('Post Type: ${appointmentType[index]}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdoptersNavigationBar(),
    );
  }
}
