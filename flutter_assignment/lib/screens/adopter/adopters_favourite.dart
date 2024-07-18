import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'components/home_post.dart';
import 'default/adopters_default_header.dart';
import 'default/adopters_design.dart';
import 'default/adopters_navigation_bar.dart';

class AdoptersFavourite extends StatelessWidget {
  const AdoptersFavourite({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultHeader(),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.userDetails == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('favorites').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              List<DocumentSnapshot> documents =
                  snapshot.data!.docs.where((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return data['userUid'] == provider.userDetails!['uid'];
              }).toList();

              if (documents.isEmpty) {
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
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data =
                            documents[index].data() as Map<String, dynamic>;
                        return HomePost(
                          postName: data['postName'] ?? '',
                          postImage: data['postImage'] ?? '',
                          postPetName: data['postPetName'] ?? '',
                          postType: data['postType'] ?? '',
                          postDescription: data['postDescription'] ?? '',
                          sellerUid: data['sellerUid'] ?? '',
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
