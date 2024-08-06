import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment/viewmodels/user_authentication.dart';
import 'package:provider/provider.dart';
import 'components/home_post.dart';
import 'default/adopters_default_header.dart';
import 'default/adopters_design.dart';
import 'default/adopters_navigation_bar.dart';
 
class AdoptersFavourite extends StatefulWidget {
  const AdoptersFavourite({Key? key}) : super(key: key);
 
  @override
  _AdoptersFavouriteState createState() => _AdoptersFavouriteState();
}
 
class _AdoptersFavouriteState extends State<AdoptersFavourite> {
  List<DocumentSnapshot> favoritePosts = [];
 
  void _removeFavoritePost(String postName) {
    setState(() {
      favoritePosts.removeWhere((post) => post['postName'] == postName);
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultHeader(),
      body: Consumer<UserAuthentication>(
        builder: (context, provider, child) {
          if (provider.userDetails == null) {
            return const Center(child: CircularProgressIndicator());
          }
 
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('favorites')
                .where('uid', isEqualTo: provider.userDetails!['uid'])
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
 
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
 
              favoritePosts = snapshot.data!.docs;
 
              if (favoritePosts.isEmpty) {
                return Center(
                  child: Text(
                    "No Favorite Post",
                    style: TextStyle(fontSize: Design.emptyPageSize),
                  ),
                );
              }
 
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Your Favorite Posts',
                      style: TextStyle(fontSize: Design.pageTitle),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: favoritePosts.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data =
                            favoritePosts[index].data() as Map<String, dynamic>;
                        return HomePost(
                          postName: data['postName'] ?? '',
                          postImage: data['postImage'] ?? '',
                          postPetName: data['postPetName'] ?? '',
                          postPurpose: data['postPurpose'] ?? '',
                          postDescription: data['postDescription'] ?? '',
                          sellerUid: data['sellerUid'] ?? '',
                          location: data['location'] ?? '',
                          species: data['species'] ?? '',
                          fee: data['fee'] ?? '',
                          onFavorite: () {
                            // Optionally handle the favorite action if needed
                          },
                          onUnfavorite: () => _removeFavoritePost(data['postName']),
                          showBookButton: true, // Show the Book button in favorites
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: const AdoptersNavigationBar(),
    );
  }
}
 