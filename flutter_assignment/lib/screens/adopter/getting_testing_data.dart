import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_navigation_bar.dart';

class GettingTestingData extends StatelessWidget {
  const GettingTestingData({super.key});

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    try {
      final imageUrl = await FireStorageService.loadImage(context, imageName);
      return Image.network(imageUrl, fit: BoxFit.scaleDown);
    } catch (e) {
      return const Text('Error loading image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Testing Data')),
      body: FutureBuilder<Widget>(
        future: _getImage(
            context, '1721156780502'), // Replace with your actual image path
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading image'));
          } else if (snapshot.hasData) {
            return Center(child: snapshot.data);
          } else {
            return const Center(child: Text('No image available'));
          }
        },
      ),
      bottomNavigationBar: AdoptersNavigationBar(),
    );
  }
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<String> loadImage(
      BuildContext context, String imageName) async {
    try {
      return await FirebaseStorage.instance
          .ref()
          .child('images/$imageName')
          .getDownloadURL();
    } catch (e) {
      throw Exception('Error loading image URL: $e');
    }
  }
}
