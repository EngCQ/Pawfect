import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                TextFormField(
                  controller: controllerName,
                  decoration: const InputDecoration(),
                ),
                TextFormField(
                  controller: controllerPetName,
                  decoration: const InputDecoration(),
                ),
                TextFormField(
                  controller: controllerDescription,
                  decoration: const InputDecoration(),
                ),
                TextFormField(
                  controller: controllerStatus,
                  decoration: const InputDecoration(),
                ),
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
                    child: const Text('Submit'))
              ],
            )));
  }
}
