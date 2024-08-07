import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  final CollectionReference petsRef = FirebaseFirestore.instance.collection('pets');
  final CollectionReference appointmentsRef = FirebaseFirestore.instance.collection('bookings');
  final CollectionReference feedbacksRef = FirebaseFirestore.instance.collection('feedback');

  Stream<int> getTotalUsers() {
    return usersRef.snapshots().map((snapshot) => snapshot.size);
  }

  Stream<int> getTotalPetsAdded() {
    return petsRef.snapshots().map((snapshot) => snapshot.size);
  }

  Stream<int> getTotalAppointments() {
    return appointmentsRef.snapshots().map((snapshot) => snapshot.size);
  }

  Stream<int> getTotalFeedbacks() {
    return feedbacksRef.snapshots().map((snapshot) => snapshot.size);
  }

  Stream<int> getTotalAdopters() {
    return usersRef.where('role', isEqualTo: 'Adopter').snapshots().map((snapshot) => snapshot.size);
  }

  Stream<int> getTotalSellers() {
    return usersRef.where('role', isEqualTo: 'Seller').snapshots().map((snapshot) => snapshot.size);
  }

  Stream<Map<String, int>> getTotalAdoptersAndSellers() {
    return CombineLatestStream.list<int>([
      getTotalAdopters(),
      getTotalSellers(),
    ]).map((values) {
      return {'Adopters': values[0], 'Sellers': values[1]};
    });
  }

  Stream<int> getTotalAdoptionPets() {
    return petsRef.where('purpose', isEqualTo: 'Adoption').snapshots().map((snapshot) => snapshot.size);
  }

  Stream<int> getTotalLostPets() {
    return petsRef.where('purpose', isEqualTo: 'Lost').snapshots().map((snapshot) => snapshot.size);
  }

  Stream<Map<String, int>> getTotalAdoptionAndLostPets() {
    return CombineLatestStream.list<int>([
      getTotalAdoptionPets(),
      getTotalLostPets(),
    ]).map((values) {
      return {'Adoption': values[0], 'Lost': values[1]};
    });
  }
}
