import 'package:flutter/material.dart';
import 'package:flutter_assignment/routes.dart';

class Booking extends StatelessWidget {
  const Booking({
    super.key,
    required this.image,
    required this.name,
    required this.date,
    required this.time,
    required this.phoneNumber,
    required this.notes,
    required this.postType,
    required this.postDescription,
  });

  final String image;
  final String name;
  final String date;
  final String time;
  final String phoneNumber;
  final String notes;
  final String postType;
  final String postDescription;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        leading: image.isNotEmpty
            ? Image.network(image, fit: BoxFit.cover, width: 50, height: 50)
            : const Icon(Icons.pets),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: $date'),
            Text('Time: $time'),
            Text('Phone: $phoneNumber'),
            Text('Notes: $notes'),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.adopterBookingDetails,
            arguments: {
              'postName': name,
              'postImage': image,
              'postPetName': name,
              'postType': postType,
              'postDescription': postDescription,
              'date': date,
              'time': time,
              'phoneNumber': phoneNumber,
              'notes': notes,
            },
          );
        },
      ),
    );
  }
}
