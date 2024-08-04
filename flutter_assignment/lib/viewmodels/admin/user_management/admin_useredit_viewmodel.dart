import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/user_model.dart';

class AdminEditUserViewModel extends ChangeNotifier {
  final String userId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String _selectedRole = 'Adopter';
  File? _selectedImage;
  ImageSource _imageSource = ImageSource.gallery;
  bool _isLoading = false;
  String? _emailError;
  String? _profileImageUrl;

  String get selectedRole => _selectedRole;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
  ImageSource get imageSource => _imageSource;
  String? get emailError => _emailError;
  String? get profileImageUrl => _profileImageUrl;
  String? get phoneCountryCode => _phoneCountryCode;
  String? get phoneNumber => _phoneNumber;

  String? _phoneNumber;
  String? _phoneCountryCode;

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

  set imageSource(ImageSource value) {
    _imageSource = value;
    notifyListeners();
  }

  set emailError(String? value) {
    _emailError = value;
    notifyListeners();
  }

  set profileImageUrl(String? value) {
    _profileImageUrl = value;
    notifyListeners();
  }

  AdminEditUserViewModel({required this.userId}) {
    fetchUserData();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    locationController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userData = userDoc.data();

    if (userData != null) {
      UserModel userModel = UserModel.fromMap(userData);
      fullNameController.text = userModel.fullName;
      emailController.text = userModel.email;
      locationController.text = userModel.location;
      selectedRole = userModel.role;
      _phoneNumber = userModel.phoneNumber?.split(' ')[1]; // Assuming the format is "countryCode number"
      _phoneCountryCode = userModel.phoneNumber?.split(' ')[0];
      phoneNumberController.text = _phoneNumber ?? '';
      profileImageUrl = userModel.profileImage;
      notifyListeners();
    }
  }

  Future<void> getImage() async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource, imageQuality: 70);
    if (pickedImage != null) {
      selectedImage = File(pickedImage.path);
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

  Future<void> submitForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      emailError = null;
      notifyListeners();

      try {
        String? imageUrl;
        if (selectedImage != null) {
          imageUrl = await uploadImage(selectedImage!);
        }

        // Fetch current isOnline and lastSeen values
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        final userData = userDoc.data();

        if (userData != null) {
          bool isOnline = userData['isOnline'];
          DateTime? lastSeen = userData['lastSeen'] != null ? (userData['lastSeen'] as Timestamp).toDate() : null;

          // Create a UserModel and update user data in Firestore
          UserModel updatedUser = UserModel(
            uid: userId,
            email: emailController.text,
            fullName: fullNameController.text,
            role: selectedRole,
            location: locationController.text,
            phoneNumber: '$_phoneCountryCode $_phoneNumber',
            profileImage: imageUrl ?? profileImageUrl,
            isOnline: isOnline, // Preserve the isOnline value
            lastSeen: lastSeen, // Preserve the lastSeen value
          );

          await FirebaseFirestore.instance.collection('users').doc(userId).update(updatedUser.toMap());

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully!')),
          );

          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        isLoading = false;
        notifyListeners();
      }
    } else {
      print('Form is not valid');
    }
  }

  Future<void> sendPasswordResetLink(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset link sent to email successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send password reset link. Please try again.')),
      );
    }
  }

  void setPhoneNumber(String phoneNumber, String phoneCountryCode) {
    _phoneNumber = phoneNumber;
    _phoneCountryCode = phoneCountryCode;
    notifyListeners();
  }
}
