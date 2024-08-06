import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/models/pet_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class PetViewModel extends ChangeNotifier {
  final String sellerUid;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String species = 'Dog'; // Default species
  String purpose = 'Adoption'; // Default purpose
  File? selectedImage;
  ImageSource imageSource = ImageSource.gallery; // Default image source
  bool isLoading = false;
  final Logger logger = Logger(); // Initialize logger

  PetViewModel({required this.sellerUid});

  Future<void> getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource, imageQuality: 70);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void removeImage() {
    selectedImage = null;
    notifyListeners();
  }

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
      logger.e('Image upload error', error: e); // Log the error
      return null;
    }
  }

  Future<bool> submitForm() async {
    if (formKey.currentState!.validate()) {
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
        species: species,
        purpose: purpose,
        fee: feeController.text,
        location: locationController.text,
        description: descriptionController.text,
        imageUrl: imageUrl,
      );

      try {
        // Add form data to Firestore using PetModel's toMap method
        final docRef = await FirebaseFirestore.instance.collection('pets').add(pet.toMap());

        logger.i('Document added with ID: ${docRef.id}'); // Log info about added document
        return true;
      } catch (e) {
        logger.e('Error adding pet to Firestore', error: e); // Log the error
        return false;
      } finally {
        setLoading(false);
      }
    } else {
      logger.w('Form is not valid'); // Log warning for invalid form
      return false;
    }
  }
}
