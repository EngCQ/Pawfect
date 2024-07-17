import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AddingTestingData extends StatefulWidget {
  const AddingTestingData({super.key});

  @override
  State<StatefulWidget> createState() => _AddingTestingDataState();
}

class _AddingTestingDataState extends State<AddingTestingData> {
  final TextEditingController controllerPetName = TextEditingController();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerStatus = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String> _uploadImage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef =
        FirebaseStorage.instance.ref().child('images/$fileName');
    UploadTask uploadTask = storageRef.putFile(image);
    await uploadTask;
    return 'images/$fileName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: controllerName,
                decoration: const InputDecoration(labelText: 'User Name'),
              ),
              TextFormField(
                controller: controllerPetName,
                decoration: const InputDecoration(labelText: 'Pet Name'),
              ),
              TextFormField(
                controller: controllerDescription,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: controllerStatus,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 20),
              _image == null
                  ? const Text('No image selected.')
                  : Image.file(_image!),
              ElevatedButton(
                  onPressed: _pickImage, child: const Text('Pick Image')),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    if (_image != null) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                      try {
                        String filePath = await _uploadImage(_image!);
                        CollectionReference collRef = FirebaseFirestore.instance
                            .collection("adopters_post");
                        await collRef.add({
                          'userName': controllerName.text,
                          'petName': controllerPetName.text,
                          'description': controllerDescription.text,
                          'type': controllerStatus.text,
                          'imagePath': filePath // Save file path
                        });

                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Post submitted successfully')),
                        );
                      } catch (e) {
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to submit post: $e')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please pick an image')),
                      );
                    }
                  },
                  child: const Text('Submit')),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AdoptersNavigationBar(),
    );
  }
}
