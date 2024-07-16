import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingForm extends StatelessWidget {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerPetName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerStatus = TextEditingController();

  BookingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The background widget, you can replace it with your desired background
          Container(
            color: Colors.white,
          ),
          // The form container
          Center(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: controllerName,
                      decoration: const InputDecoration(
                        labelText: 'User Name',
                      ),
                    ),
                    TextFormField(
                      controller: controllerPetName,
                      decoration: const InputDecoration(
                        labelText: 'Pet Name',
                      ),
                    ),
                    TextFormField(
                      controller: controllerDescription,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    TextFormField(
                      controller: controllerStatus,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        CollectionReference collRef = FirebaseFirestore.instance
                            .collection("adopters_post");
                        collRef.add({
                          'userName': controllerName.text,
                          'petName': controllerPetName.text,
                          'description': controllerDescription.text,
                          'type': controllerStatus.text,
                        });
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
