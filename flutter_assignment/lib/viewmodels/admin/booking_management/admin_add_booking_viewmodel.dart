import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment/models/pet_model.dart';
import 'package:flutter_assignment/models/booking_model.dart';
import 'package:flutter_assignment/models/user_model.dart';

class AppointmentViewModel extends ChangeNotifier {
  final formKeyInstance = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final notesController = TextEditingController();

  PetModel? petDetails;
  UserModel? sellerDetails;
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> fetchPetDetails(String petUid) async {
    try {
      setLoading(true);
      DocumentSnapshot petSnapshot =
          await FirebaseFirestore.instance.collection('pets').doc(petUid).get();
      if (petSnapshot.exists) {
        petDetails = PetModel.fromFirestore(petSnapshot);
      } else {
        print('Document does not exist!');
      }
    } catch (e) {
      print(e.toString()); // Handle error
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchSellerDetails(String sellerUid) async {
    try {
      setLoading(true);
      DocumentSnapshot sellerSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(sellerUid).get();
      if (sellerSnapshot.exists) {
        sellerDetails = UserModel.fromMap(sellerSnapshot.data() as Map<String, dynamic>);
      } else {
        print('Seller document does not exist!');
      }
    } catch (e) {
      print(e.toString()); // Handle error
    } finally {
      setLoading(false);
    }
  }

  Future<void> submitBooking(
      String sellerUid, String adopterUid, PetModel petDetails) async {
    try {
      setLoading(true);

      Booking booking = Booking(
        uid: adopterUid,
        bookingsId: '',
        date: dateController.text,
        description: petDetails.description,
        fee: petDetails.fee,
        imageUrl: petDetails.imageUrl,
        location: petDetails.location,
        notes: notesController.text,
        petName: petDetails.petName,
        purpose: petDetails.purpose,
        sellerUid: sellerUid,
        phoneNumber: sellerDetails?.phoneNumber ?? '',
        species: petDetails.species,
        time: timeController.text,
      );

      // Add a new document
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('bookings')
          .add(booking.toMap());

      // Update the document with its own ID
      await docRef.update({
        'bookingsId': docRef.id,
      });

      // Reset form fields after successful submission
      dateController.clear();
      timeController.clear();
      notesController.clear();

      setLoading(false);
      notifyListeners();
    } catch (e) {
      setLoading(false);
      print(e.toString()); // Handle error
      throw e;
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
