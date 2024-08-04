import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/user_model.dart';

class AdminUserViewModel extends ChangeNotifier {
  bool isAdoptersSelected = true;
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  CollectionReference get usersRef => FirebaseFirestore.instance.collection('users');

  Query get usersQuery {
    return isAdoptersSelected
        ? usersRef.where('role', isEqualTo: 'Adopter')
        : usersRef.where('role', isEqualTo: 'Seller');
  }

  void toggleRoleSelection(int index) {
    isAdoptersSelected = index == 0;
    notifyListeners();
  }

  Future<void> deleteUser(String userId) async {
    await usersRef.doc(userId).delete();
  }

  List<UserModel> getFilteredUsers(List<DocumentSnapshot> users) {
    final searchText = searchController.text.toLowerCase();
    return users.where((user) {
      final data = user.data() as Map<String, dynamic>;
      final fullName = data['fullName'].toString().toLowerCase();
      final email = data['email'].toString().toLowerCase();
      final userId = data['uid'].toString().toLowerCase();
      return fullName.contains(searchText) ||
          email.contains(searchText) ||
          userId.contains(searchText);
    }).map((user) {
      final data = user.data() as Map<String, dynamic>;
      return UserModel.fromMap(data);
    }).toList();
  }
}
