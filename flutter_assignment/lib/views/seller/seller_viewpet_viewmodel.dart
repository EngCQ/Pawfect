import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetViewModel extends ChangeNotifier {
  final String sellerUid;
  bool isNewPetSelected = true;
  final TextEditingController searchController = TextEditingController();

  PetViewModel({required this.sellerUid});

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  CollectionReference get petsRef => FirebaseFirestore.instance.collection('pets');

  Query get petsQuery {
    // Filter pets by the seller's UID
    final query = petsRef.where('sellerUid', isEqualTo: sellerUid);
    return isNewPetSelected
        ? query.where('purpose', isEqualTo: 'Adoption')
        : query.where('purpose', isEqualTo: 'Lost');
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
