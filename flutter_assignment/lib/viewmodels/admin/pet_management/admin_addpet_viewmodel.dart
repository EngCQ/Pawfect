import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/models/pet_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class PetViewModel extends ChangeNotifier {
  final String sellerUid;
  final formKeyInstance = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? species = 'Dog';
  String? purpose = 'Adoption';
  File? selectedImage;
  ImageSource? imageSource;
  bool isLoading = false;
  final logger = Logger(); // Initialize logger

  PetViewModel({required this.sellerUid});

  Future<void> getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource!);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  // void removeImage() {
  //   selectedImage = null;
  //   notifyListeners();
  // }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<String?> uploadImage(File image) async {
    try {
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('pet_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageReference.putFile(image);
      final completedTask = await uploadTask;
      return await completedTask.ref.getDownloadURL();
    } catch (e) {
      logger.e('Image upload error', error: e); // Use logger instead of print
      return null;
    }
  }

  Future<bool> submitForm() async {
    if (formKeyInstance.currentState!.validate()) {
      setLoading(true);

      String? imageUrl;
      if (selectedImage != null) {
        imageUrl = await uploadImage(selectedImage!);
        if (imageUrl == null) {
          setLoading(false);
          return false;
        }
      }

      // Create a PetModel instance
      PetModel pet = PetModel(
        sellerUid: sellerUid,
        petName: nameController.text,
        species: species!,
        purpose: purpose!,
        fee: feeController.text,
        location: locationController.text,
        description: descriptionController.text,
        imageUrl: imageUrl,
      );

      try {
        // Add form data to Firestore using PetModel's toMap method
        final docRef = await FirebaseFirestore.instance.collection('pets').add(pet.toMap());

        logger.i('Document added with ID: ${docRef.id}'); // Use logger for info
        return true;
      } catch (e) {
        logger.e('Error adding pet to Firestore', error: e); // Use logger for error
        return false;
      } finally {
        setLoading(false);
      }
    } else {
      logger.w('Form is not valid'); // Use logger for warning
      return false;
    }
  }
}
