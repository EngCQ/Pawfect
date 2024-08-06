import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_assignment/viewmodels/user_authentication.dart';
import 'components/home_post.dart';
import 'sellers_default_header.dart'; 
import 'sellers_navigation_bar.dart'; 

class SellersHome extends StatefulWidget {
  const SellersHome({super.key});

  @override
  _SellersHomeState createState() => _SellersHomeState();
}

class _SellersHomeState extends State<SellersHome> {
  List<DocumentSnapshot> posts = [];

  Future<String> _getImageUrl(String imagePath) async {
    try {
      return await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
    } catch (e) {
      print("Error fetching image URL: $e");
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final searchText = args?['searchText'] ?? '';
    final searchAdoption = args?['searchAdoption'] ?? true;
    final searchMissing = args?['searchMissing'] ?? true;

    final userDetails = Provider.of<UserAuthentication>(context).userDetails ?? {};
    final userEmail = userDetails['email'] ?? 'User';
    final userName = userDetails['fullName'] ?? 'User';

    return Scaffold(
      appBar: const SellersDefaultHeader(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome, $userName',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  userEmail,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('pets').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No posts available'));
                }

                posts = snapshot.data!.docs.where((post) {
                  final postPurpose = post['purpose'];
                  final postUserName = post['petName'];

                  final matchesSearchText =
                      searchText.isEmpty || postUserName.contains(searchText);
                  final matchesAdoption = searchAdoption && postPurpose == 'Adoption';
                  final matchesMissing = searchMissing && postPurpose == 'Lost';

                  return matchesSearchText && (matchesAdoption || matchesMissing);
                }).toList();

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final imageUrl = post['imageUrl'] ?? '';

                    return HomePost(
                      postName: post['petName'],
                      postImage: imageUrl,
                      postPetName: post['petName'],
                      postPurpose: post['purpose'],
                      postDescription: post['description'],
                      sellerUid: post['sellerUid'],
                      location: post['location'],
                      species: post['species'],
                      fee: post['fee'],
                      onFavorite: () {
                        // Handle favorite if needed, or remove the callback if not used
                      },
                      onUnfavorite: () {
                        // Handle unfavorite if needed
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SellersNavigationBar(), 
    );
  }
}
