import 'package:flutter/material.dart';
import 'default/adopters_default_header.dart';
import 'default/adopters_design.dart';
import 'default/adopters_navigation_bar.dart';

class AdoptersAppointment extends StatelessWidget {
  AdoptersAppointment({super.key});

  // List of all appointment details
  final List<String> appointmentName = [
    'post 1',
    'post 2',
    'post 3',
  ];

  final List<String> appointmenImage = [
    'lib/images/pets.jpeg',
    'lib/images/pets.jpeg',
    'lib/images/pets.jpeg',
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
      body: appointmentName.isEmpty
          ? Center(
              child: Text(
                "No Appointment",
                style: TextStyle(fontSize: Design.emptyPageSize),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Your Booking',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.left,
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
