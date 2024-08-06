import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment/viewmodels/admin/booking_management/admin_edit_booking_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_assignment/widgets/drawer_admin.dart';
import 'package:flutter_assignment/routes.dart'; // Make sure to import AppRoutes
import 'package:flutter_assignment/models/booking_model.dart'; // Import the Booking model
import 'package:flutter_assignment/viewmodels/user_authentication.dart';
import 'admin_edit_booking.dart'; // Import the AdminEditBooking screen

class AdminBookingManagement extends StatefulWidget {
  const AdminBookingManagement({super.key});

  @override
  AdminBookingManagementState createState() => AdminBookingManagementState();
}

class AdminBookingManagementState extends State<AdminBookingManagement> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance.collection('bookings').doc(bookingId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete booking: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Booking'),
          content: const Text('Are you sure you want to delete this booking? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteBooking(bookingId);
                Navigator.of(context).pop();
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
    final userAuth = Provider.of<UserAuthentication>(context);
    final userEmail = userAuth.user?.email ?? 'User';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0583CB),
        title: const Text('Bookings'),
        actions: [
          Row(
            children: [
              Text(
                userEmail,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      drawer: const DrawerAdmin(currentRoute: '/adminBookingManagement'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.adminSelectSellerAppointment);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('ADD'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by booking ID',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            updateSearchQuery(searchController.text);
                          },
                        ),
                      ),
                      onChanged: (value) {
                        updateSearchQuery(value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('Error fetching data.'));
                    }

                    final bookings = snapshot.data?.docs ?? [];
                    final filteredBookings = bookings.where((booking) {
                      final bookingData = booking.data() as Map<String, dynamic>;
                      final bookingId = bookingData['bookingsId'] ?? '';

                      return bookingId.toLowerCase().contains(searchQuery);
                    }).toList();

                    if (filteredBookings.isEmpty) {
                      return const Center(child: Text('No bookings found.'));
                    }

                    return ListView.builder(
                      itemCount: filteredBookings.length,
                      itemBuilder: (context, index) {
                        final booking = filteredBookings[index];
                        final bookingModel = Booking.fromFirestore(booking);
                        final bookingId = bookingModel.bookingsId;
                        final bookingDate = bookingModel.date;
                        final bookingTime = bookingModel.time;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text('Booking $bookingId'),
                            subtitle: Text('Date: $bookingDate\nTime: $bookingTime'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChangeNotifierProvider(
                                          create: (_) => EditBookingViewModel(),
                                          child: AdminEditBooking(bookingId: booking.id),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(context, booking.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
