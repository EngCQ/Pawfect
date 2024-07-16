import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'components/home_post.dart';
import 'default/adopters_default_header.dart';
import 'default/adopters_navigation_bar.dart';
import 'package:flutter_assignment/routes.dart';

class AdoptersHome extends StatelessWidget {
  AdoptersHome({super.key});

  final List<String> postImage = [
    'lib/images/pets.jpeg',
    'lib/images/pets.jpeg',
    'lib/images/pets.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultHeader(),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('adopters_post').snapshots(),
        builder: (context, snapshot) {
          //performing with different conditions
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return HomePost(
                postName: post['userName'],
                postImage: postImage[index %
                    postImage.length], // Ensure image index is within bounds
                postPetName: post['petName'],
                postType: post['type'],
              );
            },
          );
        },
      ),
      bottomNavigationBar: const AdoptersNavigationBar(),
    );
  }
}
