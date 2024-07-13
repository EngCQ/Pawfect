import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

class AddingTestingData extends StatefulWidget {
  const AddingTestingData({super.key});

  @override
  State<StatefulWidget> createState() => _AddingTestingDataState();
}

class _AddingTestingDataState extends State<AddingTestingData> {
  final TextEditingController controllerName = TextEditingController();
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
                  controller: controllerStatus,
                  decoration: const InputDecoration(),
                ),
                ElevatedButton(
                    onPressed: () {
                      CollectionReference collRef =
                          FirebaseFirestore.instance.collection("adopter_post");
                      collRef.add({
                        'Name': controllerName.text,
                        'Status': controllerStatus.text,
                      });
                    },
                    child: const Text('Submit'))
              ],
            )));
  }
}
