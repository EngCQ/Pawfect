import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPetViewModel extends ChangeNotifier {
  bool isNewPetSelected = true;
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  CollectionReference get petsRef => FirebaseFirestore.instance.collection('pets');

  Query get petsQuery {
    return isNewPetSelected
        ? petsRef.where('purpose', isEqualTo: 'Adoption')
        : petsRef.where('purpose', isEqualTo: 'Lost');
  }

  void togglePetSelection(int index) {
    isNewPetSelected = index == 0;
    notifyListeners();
  }

  Future<void> deletePet(String petId) async {
    await petsRef.doc(petId).delete();
  }

  List<DocumentSnapshot> getFilteredPets(List<DocumentSnapshot> pets) {
    final searchText = searchController.text.toLowerCase();
    return pets.where((pet) {
      final data = pet.data() as Map<String, dynamic>;
      final petName = data['petName'].toString().toLowerCase();
      return petName.contains(searchText);
    }).toList();
  }
}
