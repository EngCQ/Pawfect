import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/providers/user_provider.dart';
import 'package:flutter_assignment/screens/adopter/components/booking.dart';
import 'package:provider/provider.dart';
import 'default/adopters_default_header.dart';
import 'default/adopters_design.dart';
import 'default/adopters_navigation_bar.dart';

class AdoptersAppointment extends StatelessWidget {
  AdoptersAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultHeader(),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.userDetails == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('bookings').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              List<DocumentSnapshot> documents =
                  snapshot.data!.docs.where((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return data['uid'] == provider.userDetails!['uid'];
              }).toList();

              if (documents.isEmpty) {
                return Center(
                  child: Text(
                    "No Appointment",
                    style: TextStyle(fontSize: Design.emptyPageSize),
                  ),
                );
              }

              return Column(
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
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data =
                            documents[index].data() as Map<String, dynamic>;
                        DateTime appointmentDate = data['date'].toDate();
                        bool isPast = appointmentDate.isBefore(DateTime.now());

                        return Booking(
                          image: data['postImage'] ?? '',
                          name: data['postName'] ?? '',
                          date: appointmentDate.toString().split(' ')[0],
                          time: data['time'] ?? '',
                          phoneNumber: data['phoneNumber'] ?? '',
                          notes: data['notes'] ?? '',
                          postType: data['postType'] ?? '',
                          postDescription: data['postDescription'] ?? '',
                          cardColor: isPast ? Colors.red : Colors.green,
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
      bottomNavigationBar: const AdoptersNavigationBar(),
    );
  }
}
