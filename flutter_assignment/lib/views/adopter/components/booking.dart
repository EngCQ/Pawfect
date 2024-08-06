// import 'package:flutter/material.dart';
// import 'package:flutter_assignment/routes.dart';

// class Booking extends StatelessWidget {
//   const Booking({
//     super.key,
//     required this.bookingId,
//     required this.image,
//     required this.name,
//     required this.date,
//     required this.time,
//     required this.phoneNumber,
//     required this.notes,
//     required this.postType,
//     required this.postDescription,
//     required this.cardColor,
//   });

//   final String bookingId; // Add bookingId field
//   final String image;
//   final String name;
//   final String date;
//   final String time;
//   final String phoneNumber;
//   final String notes;
//   final String postType;
//   final String postDescription;
//   final Color cardColor;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: cardColor,
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       child: ListTile(
//         leading: image.isNotEmpty
//             ? Image.network(image, fit: BoxFit.cover, width: 50, height: 50)
//             : const Icon(Icons.pets),
//         title: Text(name),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Date: $date'),
//             Text('Time: $time'),
//             Text('Phone: $phoneNumber'),
//             Text('Notes: $notes'),
//           ],
//         ),
//         onTap: () {
//           Navigator.pushNamed(
//             context,
//             AppRoutes.adopterBookingDetails,
//             arguments: {
//               'bookingId': bookingId,
//               'postName': name,
//               'postImage': image,
//               'postPetName': name,
//               'postType': postType,
//               'postDescription': postDescription,
//               'date': date,
//               'time': time,
//               'phoneNumber': phoneNumber,
//               'notes': notes,
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
class Booking extends StatelessWidget {
  const Booking({
    super.key,
    required this.bookingId,
    required this.image,
    required this.name,
    required this.date,
    required this.time,
    required this.phoneNumber,
    required this.notes,
    required this.postType,
    required this.postDescription,
    required this.cardColor,
  });
 
  final String bookingId;
  final String image;
  final String name;
  final String date;
  final String time;
  final String phoneNumber;
  final String notes;
  final String postType;
  final String postDescription;
  final Color cardColor;
 
  Future<void> _cancelBooking(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
 
      // Show confirmation dialog
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cancel Booking'),
          content: const Text('Are you sure you want to cancel this booking?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      );
 
      if (shouldDelete == true) {
        // Delete the booking record from Firestore
        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(bookingId)
            .delete();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You need to be logged in to cancel bookings')),
      );
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: image.isNotEmpty
                  ? Image.network(image,
                      fit: BoxFit.cover, width: 50, height: 50)
                  : const Icon(Icons.pets),
              title: Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: $date'),
                  Text('Time: $time'),
                  Text('Phone: $phoneNumber'),
                  Text('Notes: $notes'),
                ],
              ),
            ),
            const Divider(),
            Center(
              child: ElevatedButton(
                onPressed: () => _cancelBooking(context),
                child: const Text('Cancel Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 

