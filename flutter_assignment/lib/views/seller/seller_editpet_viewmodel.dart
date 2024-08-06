import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/models/pet_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class SellerEditPetViewModel extends ChangeNotifier {
  final String petId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController sellerIdController = TextEditingController();
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();

  String _selectedPurpose = 'Adoption';
  File? _selectedImage;
  ImageSource _imageSource = ImageSource.gallery;
  bool _isLoading = false;
  String? _imageUrl;
  final logger = Logger();

  String get selectedPurpose => _selectedPurpose;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
  ImageSource get imageSource => _imageSource;
  String? get imageUrl => _imageUrl;

  set selectedPurpose(String value) {
    _selectedPurpose = value;
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

  set imageUrl(String? value) {
    _imageUrl = value;
    notifyListeners();
  }

  SellerEditPetViewModel({required this.petId}) {
    fetchPetData();
  }

  @override
  void dispose() {
    sellerIdController.dispose();
    petNameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    feeController.dispose();
    speciesController.dispose();
    super.dispose();
  }

  Future<void> fetchPetData() async {
    final petDoc = await FirebaseFirestore.instance.collection('pets').doc(petId).get();
    final petData = petDoc.data();

    if (petData != null) {
      sellerIdController.text = petData['sellerUid'];
      petNameController.text = petData['petName'];
      descriptionController.text = petData['description'];
      locationController.text = petData['location'];
      feeController.text = petData['fee'];
      speciesController.text = petData['species'];
      selectedPurpose = petData['purpose'];
      imageUrl = petData['imageUrl'];
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
          .child('pet_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageReference.putFile(image);
      final completedTask = await uploadTask;
      return await completedTask.ref.getDownloadURL();
    } catch (e) {
      logger.e('Image upload error', error: e);
      return null;
    }
  }

  Future<void> submitForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();

      try {
        String? imageUrl;
        if (selectedImage != null) {
          imageUrl = await uploadImage(selectedImage!);
        }

        // Use PetModel to create the updated pet data
        PetModel updatedPet = PetModel(
          sellerUid: sellerIdController.text,
          petName: petNameController.text,
          species: speciesController.text,
          purpose: selectedPurpose,
          fee: feeController.text,
          location: locationController.text,
          description: descriptionController.text,
          imageUrl: imageUrl ?? _imageUrl,
        );

        await FirebaseFirestore.instance.collection('pets').doc(petId).update(updatedPet.toMap());

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet Description updated successfully!')),
        );

        if (!context.mounted) return;
        Navigator.pop(context);
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        isLoading = false;
        notifyListeners();
      }
    } else {
      logger.w('Form is not valid');
    }
  }
}
