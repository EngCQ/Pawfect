import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment/models/booking_model.dart';

class EditBookingViewModel extends ChangeNotifier {
  final formKeyInstance = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  Booking? bookingDetails;
  bool isLoading = false;

  Future<void> fetchBookingDetails(String bookingId) async {
    try {
      setLoading(true);
      DocumentSnapshot bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .get();

      if (bookingSnapshot.exists) {
        bookingDetails = Booking.fromFirestore(bookingSnapshot);
        dateController.text = bookingDetails!.date;
        timeController.text = bookingDetails!.time;
        descriptionController.text = bookingDetails!.description;
        locationController.text = bookingDetails!.location;
      } else {
        print('Booking does not exist!');
      }
    } catch (e) {
      print(e.toString()); // Handle error
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateBooking() async {
    try {
      setLoading(true);
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingDetails!.bookingsId)
          .update({
        'date': dateController.text,
        'time': timeController.text,
        'notes': descriptionController.text,
        'location': locationController.text,
      });
    } catch (e) {
      print(e.toString()); // Handle error
      throw e;
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
