import 'package:flutter/material.dart';
import 'package:flutter_assignment/viewmodels/admin/user_management/admin_useredit_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AdminEditUser extends StatelessWidget {
  final String userId;

  const AdminEditUser({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminEditUserViewModel(userId: userId),
      child: Consumer<AdminEditUserViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit User'),
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
                                    ? (viewModel.profileImageUrl != null
                                        ? Image.network(
                                            viewModel.profileImageUrl!,
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
                        controller: viewModel.fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Current Full Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        controller: viewModel.emailController,
                        decoration: InputDecoration(
                          labelText: 'First Email',
                          border: const OutlineInputBorder(),
                          errorText: viewModel.emailError,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        controller: viewModel.phoneNumberController,
                        decoration: const InputDecoration(
                          
                          labelText: 'First Phone Number',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: viewModel.locationController,
                        decoration: const InputDecoration(
                          labelText: 'Current Location',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your location';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Current Role',
                          border: OutlineInputBorder(),
                        ),
                        value: viewModel.selectedRole,
                        items: ['Adopter', 'Seller']
                            .map((role) => DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role),
                                ))
                            .toList(),
                        onChanged: (value) {
                          viewModel.selectedRole = value!;
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
                                'UPDATE USER',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: viewModel.isLoading ? null : () => viewModel.sendPasswordResetLink(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
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
                                'SEND PASSWORD RESET LINK',
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
