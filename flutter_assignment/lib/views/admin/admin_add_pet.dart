import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/admin/pet_management/admin_addpet_viewmodel.dart';
import 'package:flutter/services.dart'; // Import for input formatters

class AdminAddPet extends StatefulWidget {
  final String sellerUid;

  const AdminAddPet({super.key, required this.sellerUid});

  @override
  AdminAddPetState createState() => AdminAddPetState();
}

class AdminAddPetState extends State<AdminAddPet> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PetViewModel(sellerUid: widget.sellerUid),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0583CB),
          title: const Text('Add new/lost Pet'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<PetViewModel>(
            builder: (context, petViewModel, child) {
              return SingleChildScrollView(
                child: Form(
                  key: petViewModel.formKeyInstance,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: widget.sellerUid,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pet Seller UID',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: petViewModel.nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Pet's Name",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the pet's name";
                          }
                          if (value.length < 3) {
                            return 'Pet name must be at least 3 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Species',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        value: petViewModel.species,
                        items: const [
                          DropdownMenuItem(value: 'Dog', child: Text('Dog')),
                          DropdownMenuItem(value: 'Cat', child: Text('Cat')),
                          DropdownMenuItem(
                              value: 'Other', child: Text('Other')),
                        ],
                        onChanged: (value) {
                          petViewModel.species = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Purpose',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        value: petViewModel.purpose,
                        items: const [
                          DropdownMenuItem(
                              value: 'Adoption', child: Text('Adoption')),
                          DropdownMenuItem(value: 'Lost', child: Text('Lost')),
                        ],
                        onChanged: (value) {
                          petViewModel.purpose = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: petViewModel.feeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Fee(RM)',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the fee";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: petViewModel.locationController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Location',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the location";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: petViewModel.descriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Descriptions',
                        ),
                        maxLines: 3,
                        // Making this field optional by removing the validator
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Picture',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Card(
                                child: petViewModel.selectedImage == null
                                    ? Image.asset(
                                        'assets/default_profile.png',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        petViewModel.selectedImage!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      petViewModel.imageSource =
                                          ImageSource.camera;
                                      petViewModel.getImage();
                                    },
                                    icon: const Icon(Icons.camera),
                                    label: const Text('Open Camera'),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      petViewModel.imageSource =
                                          ImageSource.gallery;
                                      petViewModel.getImage();
                                    },
                                    icon: const Icon(Icons.photo_album),
                                    label: const Text('Open Gallery'),
                                  ),
                                  // if (petViewModel.selectedImage != null)
                                  //   IconButton(
                                  //     icon: const Icon(Icons.delete),
                                  //     onPressed: () {
                                  //       petViewModel.removeImage();
                                  //     },
                                  //   ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: petViewModel.isLoading
                                ? null
                                : () async {
                                    if (petViewModel
                                        .formKeyInstance.currentState!
                                        .validate()) {
                                      // Print statements for each field
                                      print(
                                          'Pet Seller UID: ${widget.sellerUid}');
                                      print(
                                          "Pet's Name: ${petViewModel.nameController.text}");
                                      print('Species: ${petViewModel.species}');
                                      print('Purpose: ${petViewModel.purpose}');
                                      print(
                                          'Fee: ${petViewModel.feeController.text}');
                                      print(
                                          'Location: ${petViewModel.locationController.text}');
                                      print(
                                          'Descriptions: ${petViewModel.descriptionController.text}');
                                      if (petViewModel.selectedImage != null) {
                                        print('Image Selected');
                                      } else {
                                        print('No Image Selected');
                                      }

                                      petViewModel.setLoading(true);

                                      bool success =
                                          await petViewModel.submitForm();

                                      petViewModel.setLoading(false);

                                      if (!mounted)
                                        return; // Check if the widget is still mounted

                                      if (success) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Pet added successfully!')),
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Failed to add pet. Please try again.')),
                                        );
                                      }
                                    }
                                  },
                            child: petViewModel.isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text('ADD'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
