import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/routes.dart';
import 'package:flutter_assignment/views/seller/sellers_back_header.dart';
import 'package:flutter_assignment/views/seller/sellers_design.dart';

class SellersBookingDetails extends StatelessWidget {
  final String postName;
  final String postImage;
  final String postPetName;
  final String postPurpose;
  final String postDescription;
  final String date;
  final String time;
  final String phoneNumber;
  final String notes;
  final String bookingId; // Field to identify the booking record

  const SellersBookingDetails({
    super.key,
    required this.postName,
    required this.postImage,
    required this.postPetName,
    required this.postPurpose,
    required this.postDescription,
    required this.date,
    required this.time,
    required this.phoneNumber,
    required this.notes,
    required this.bookingId,
  });

  Future<void> deleteBooking(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .delete();
      Navigator.pushReplacementNamed(context, AppRoutes.sellerAppointment); // Updated route
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking deleted successfully'),
        ),
      );
    } catch (e) {
      print('Error deleting booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete booking: $e'),
        ),
      );
    }
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this booking?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteBooking(context); // Delete the booking
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SellersBackHeader(), // Updated AppBar
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 330,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: postImage.isNotEmpty
                            ? NetworkImage(postImage)
                            : const AssetImage('assets/bell.png') as ImageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.blue,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seller: $postName',
                    style: TextStyle(
                      fontSize: SellersDesign.descriptionTitleSize, // Updated Design reference
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: SellersDesign.descriptionDetailTopPadding, // Updated Design reference
                      bottom: 10,
                    ),
                    child: Text(
                      'Purpose: $postPurpose',
                      style: TextStyle(
                        fontSize: SellersDesign.descriptionTitleSize, // Updated Design reference
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Pet's Name: $postPetName",
                    style: TextStyle(
                      fontSize: SellersDesign.descriptionTitleSize, // Updated Design reference
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: SellersDesign.descriptionDetailTopPadding, // Updated Design reference
                    ),
                    child: Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: SellersDesign.descriptionTitleSize, // Updated Design reference
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    postDescription.isNotEmpty
                        ? postDescription
                        : 'No description provided.',
                    style: TextStyle(
                      fontSize: SellersDesign.descriptionDetailSize, // Updated Design reference
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Date: $date',
                    style: TextStyle(
                      fontSize: SellersDesign.descriptionDetailSize, // Updated Design reference
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Time: $time',
                    style: TextStyle(
                      fontSize: SellersDesign.descriptionDetailSize, // Updated Design reference
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Phone: $phoneNumber',
                    style: TextStyle(
                      fontSize: SellersDesign.descriptionDetailSize, // Updated Design reference
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Notes: ${notes.isNotEmpty ? notes : 'No additional notes.'}',
                    style: TextStyle(
                      fontSize: SellersDesign.descriptionDetailSize, // Updated Design reference
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => showDeleteConfirmationDialog(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text(
                        'Delete Booking',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
