import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_assignment/viewmodels/admin/booking_management/admin_edit_booking_viewmodel.dart';
import 'package:flutter_assignment/routes.dart'; // Adjust the path as necessary

class AdminEditBooking extends StatefulWidget {
  final String bookingId;

  const AdminEditBooking({super.key, required this.bookingId});

  @override
  AdminEditBookingState createState() => AdminEditBookingState();
}

class AdminEditBookingState extends State<AdminEditBooking> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EditBookingViewModel>(context, listen: false)
          .fetchBookingDetails(widget.bookingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 47, 131, 240),
        title: const Text('Edit Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<EditBookingViewModel>(
          builder: (context, editBookingViewModel, child) {
            return SingleChildScrollView(
              child: Form(
                key: editBookingViewModel.formKeyInstance,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (editBookingViewModel.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (editBookingViewModel.bookingDetails != null) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: editBookingViewModel.bookingDetails!.sellerUid,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Seller UID',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: editBookingViewModel.bookingDetails!.uid,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adopter UID',
                        ),
                      ),
                      const SizedBox(height: 16),
                      // TextFormField(
                      //   initialValue: editBookingViewModel.bookingDetails!.petUid,
                      //   readOnly: true,
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     labelText: 'Pet UID',
                      //   ),
                      // ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: editBookingViewModel.dateController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Appointment Date",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an appointment date';
                          }
                          return null;
                        },
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            String formattedDate =
                                "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                            editBookingViewModel.dateController.text = formattedDate;
                          }
                        },
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: editBookingViewModel.timeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Appointment Time",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an appointment time';
                          }
                          return null;
                        },
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            String formattedTime = pickedTime.format(context);
                            editBookingViewModel.timeController.text = formattedTime;
                          }
                        },
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: editBookingViewModel.descriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                        maxLines: 3,
                      ),
                      // const SizedBox(height: 16),
                      // TextFormField(
                      //   controller: editBookingViewModel.locationController,
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     labelText: 'Location',
                      //   ),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please enter a location';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      const SizedBox(height: 16),
                    ] else
                      const Text('No booking details available.'),
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: editBookingViewModel.isLoading
                              ? null
                              : () async {
                                  if (editBookingViewModel.formKeyInstance
                                      .currentState!
                                      .validate()) {
                                    try {
                                      await editBookingViewModel.updateBooking();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Booking updated successfully!')),
                                      );
                                      Navigator.pushReplacementNamed(context, AppRoutes.adminAppoManagement);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to update booking: $e')),
                                      );
                                    }
                                  }
                                },
                          child: editBookingViewModel.isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Text('UPDATE'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
