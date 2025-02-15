import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_assignment/viewmodels/seller/seller_editpet_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditPetScreen extends StatelessWidget {
  final String petId;

  const EditPetScreen({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SellerEditPetViewModel(petId: petId), // Pass an empty string for sellerUid or adapt the constructor
      child: Consumer<SellerEditPetViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Pet'),
              backgroundColor: const Color(0xFF0583CB),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: viewModel.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Card(
                                child: viewModel.selectedImage == null
                                    ? (viewModel.imageUrl != null
                                        ? Image.network(
                                            viewModel.imageUrl!,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/default_profile.png',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ))
                                    : Image.file(
                                        viewModel.selectedImage!,
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
                                      viewModel.imageSource = ImageSource.camera;
                                      viewModel.getImage();
                                    },
                                    icon: const Icon(Icons.camera),
                                    label: const Text('Open Camera'),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      viewModel.imageSource = ImageSource.gallery;
                                      viewModel.getImage();
                                    },
                                    icon: const Icon(Icons.photo_album),
                                    label: const Text('Open Gallery'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: viewModel.sellerIdController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pet Seller UID',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: viewModel.petNameController,
                        decoration: const InputDecoration(
                          labelText: 'Pet Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the pet name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: viewModel.feeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Fee',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the fee";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: viewModel.locationController,
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
                      TextFormField(
                        controller: viewModel.descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Purpose',
                          border: OutlineInputBorder(),
                        ),
                        value: viewModel.selectedPurpose,
                        items: ['Adoption', 'Lost']
                            .map((purpose) => DropdownMenuItem<String>(
                                  value: purpose,
                                  child: Text(purpose),
                                ))
                            .toList(),
                        onChanged: (value) {
                          viewModel.selectedPurpose = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: viewModel.isLoading ? null : () => viewModel.submitForm(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0583CB),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: viewModel.isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'UPDATE PET',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
