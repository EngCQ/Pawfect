import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:intl_phone_field/phone_number.dart';
import 'package:logger/logger.dart';
import '../../../models/user_model.dart';

class AdminUserManagementViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  bool _isPasswordVisible = false;
  String _selectedRole = 'Adopter';
  File? _selectedImage;
  ImageSource _imageSource = ImageSource.gallery;
  bool _isLoading = false;
  String? emailError;
  String? fullNameError;
  String? phoneError;
  final logger = Logger(); // Initialize logger
  
  String? _phoneNumber;
  String? _phoneCountryCode;

  bool get isPasswordVisible => _isPasswordVisible;
  String get selectedRole => _selectedRole;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
  ImageSource get imageSource => _imageSource;

  set isPasswordVisible(bool value) {
    _isPasswordVisible = value;
    notifyListeners();
  }

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
  void removeImage() {
    selectedImage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    
    passwordController.dispose();
    locationController.dispose();
    super.dispose();
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
      logger.e('Image upload error', error: e); // Use logger instead of print
      return null;
    }
  }

  Future<void> submitForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      emailError = null;
      fullNameError = null;
      phoneError = null;

      try {
        // Check if full name is unique
        QuerySnapshot nameQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('fullName', isEqualTo: fullNameController.text)
            .get();
        if (nameQuery.docs.isNotEmpty) {
          isLoading = false;
          fullNameError = 'Full name is already in use.';
          notifyListeners();
          return;
        }

        // Check if phone number is unique
        QuerySnapshot phoneQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber', isEqualTo: '$_phoneCountryCode $_phoneNumber')
            .get();
        if (phoneQuery.docs.isNotEmpty) {
          isLoading = false;
          phoneError = 'Phone number is already in use.';
          notifyListeners();
          return;
        }

        // Create user with Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Upload profile image if selected
        String? imageUrl;
        if (selectedImage != null) {
          imageUrl = await uploadImage(selectedImage!);
        }

        // Create a new UserModel and save it to Firestore
        UserModel newUser = UserModel(
          uid: userCredential.user!.uid,
          email: emailController.text,
          fullName: fullNameController.text,
          role: selectedRole,
          location: locationController.text,
          phoneNumber: '$_phoneCountryCode $_phoneNumber', // Add phone number with country code
          profileImage: imageUrl,
          isOnline: false,
          lastSeen: null,
        );

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(newUser.toMap());

        // Clear the form
        fullNameController.clear();
        emailController.clear();
        passwordController.clear();
        locationController.clear();
        _phoneNumber = null;
        _phoneCountryCode = null;
        selectedRole = 'Adopter';
        selectedImage = null;

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added successfully!')),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'This email is already registered.';
            emailError = errorMessage;
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            emailError = errorMessage;
            break;
          default:
            errorMessage = 'An error occurred. Please try again.';
            break;
        }

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        logger.e('Error occurred while adding user', error: e); // Use logger for error

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        isLoading = false;
        notifyListeners();
      }
    } else {
      logger.w('Form is not valid'); // Use logger for warning
    }
  }

  void setPhoneNumber(String phoneNumber, String phoneCountryCode) {
    _phoneNumber = phoneNumber;
    _phoneCountryCode = phoneCountryCode;
    notifyListeners();
  }
}
