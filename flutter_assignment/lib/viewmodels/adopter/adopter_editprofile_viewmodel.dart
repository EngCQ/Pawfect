import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_assignment/models/user_model.dart';

class UserEditProfileModel extends ChangeNotifier {
  final String userId;
  final formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String _selectedRole = 'Adopter';
  File? _selectedImage;
  bool _isLoading = true;
  String? _profileImageUrl;
  UserModel? userModel;

  String get selectedRole => _selectedRole;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
  String? get profileImageUrl => _profileImageUrl;

  set selectedRole(String value) {
    _selectedRole = value;
    notifyListeners();
  }

  set selectedImage(File? value) {
    _selectedImage = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set profileImageUrl(String? value) {
    _profileImageUrl = value;
    notifyListeners();
  }

  UserEditProfileModel({required this.userId}) {
    fetchUserData();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userData = userDoc.data();

    if (userData != null) {
      userModel = UserModel.fromMap(userData);
      fullNameController.text = userModel!.fullName;
      emailController.text = userModel!.email;
      locationController.text = userModel!.location;
      _selectedRole = userModel!.role;
      phoneNumberController.text = userModel!.phoneNumber ?? '';
      profileImageUrl = userModel!.profileImage;
      notifyListeners();
    }
    _isLoading = false;
  }

  Future<void> getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source, imageQuality: 70);
    if (pickedImage != null) {
      _selectedImage = File(pickedImage.path);
      notifyListeners();
    }
  }

  Future<String?> uploadImage(File image) async {
    try {
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageReference.putFile(image);
      final completedTask = await uploadTask;
      return await completedTask.ref.getDownloadURL();
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
  }

  Future<void> updateUserProfile(UserModel updatedUser, BuildContext context) async {
    try {
      // Check if full name is unique
      QuerySnapshot nameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('fullName', isEqualTo: fullNameController.text)
          .get();

      if (nameQuery.docs.isNotEmpty && nameQuery.docs.first.id != userId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Full name is already in use.')),
        );
        return;
      }

      if (_selectedImage != null) {
        final imageUrl = await uploadImage(_selectedImage!);
        updatedUser = UserModel(
          uid: updatedUser.uid,
          email: updatedUser.email,
          fullName: updatedUser.fullName,
          role: updatedUser.role,
          location: updatedUser.location,
          profileImage: imageUrl,
          isOnline: updatedUser.isOnline,
          lastSeen: updatedUser.lastSeen,
          phoneNumber: updatedUser.phoneNumber,
        );
      }

      await FirebaseFirestore.instance.collection('users').doc(userId).update(updatedUser.toMap());
      userModel = updatedUser;
      notifyListeners();

      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      // Navigate back with the updated user
      Navigator.pop(context, updatedUser);
    } catch (e) {
      print("Error updating user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile. Please try again.')),
      );
    }
  }
}
