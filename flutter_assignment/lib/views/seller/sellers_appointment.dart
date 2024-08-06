import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/views/seller/sellers_default_header.dart';
import 'package:flutter_assignment/views/seller/sellers_design.dart';
import 'package:flutter_assignment/views/seller/sellers_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_assignment/viewmodels/user_authentication.dart';
import 'package:flutter_assignment/views/seller/components/booking.dart'; // Adjust the import path accordingly


class SellersAppointment extends StatelessWidget {
  SellersAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SellersDefaultHeader(), // Updated header for sellers
      body: Consumer<UserAuthentication>(
        builder: (context, provider, child) {
          if (provider.userDetails == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              List<DocumentSnapshot> documents = snapshot.data!.docs.where((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return data['sellerUid'] == provider.userDetails!['uid']; // Adjust to filter by seller UID
              }).toList();

              if (documents.isEmpty) {
                return Center(
                  child: Text(
                    "No Appointments",
                    style: TextStyle(fontSize: SellersDesign.emptyPageSize), // Updated design reference
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Your Appointments',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;

                        // Handle string date conversion
                        String? postDateString = data['postDate'];
                        DateTime? appointmentDate;
                        if (postDateString != null) {
                          try {
                            appointmentDate = DateFormat('yyyy-MM-dd').parse(postDateString);
                          } catch (e) {
                            appointmentDate = null;
                          }
                        }
                        bool isPast = appointmentDate != null && appointmentDate.isBefore(DateTime.now());

                        return Booking(
                          bookingId: documents[index].id, // Pass bookingId
                          image: data['postImage'] ?? '',
                          name: data['postPetName'] ?? '',
                          date: postDateString ?? 'N/A',  // Ensure it's a string
                          time: data['time'] ?? '',
                          phoneNumber: data['phoneNumber'] ?? '',
                          notes: data['notes'] ?? '',
                          postType: data['postType'] ?? '',
                          postDescription: data['postDescription'] ?? '',
                          cardColor: appointmentDate != null && isPast ? Colors.red : Colors.green,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: const SellersNavigationBar(), // Updated navigation bar for sellers
    );
  }
}
