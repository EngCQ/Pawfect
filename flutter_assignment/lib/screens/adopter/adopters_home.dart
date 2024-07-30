import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'components/home_post.dart';
import 'default/adopters_default_header.dart';
import 'default/adopters_navigation_bar.dart';
import 'package:flutter_assignment/main.dart';

class AdoptersHome extends StatelessWidget {
  const AdoptersHome({super.key});

  Future<String> _getImageUrl(String imagePath) async {
    try {
      return await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
    } catch (e) {
      print("Error fetching image URL: $e");
      throw e;
    }
  }

  void _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final searchText = args?['searchText'] ?? '';
    final searchAdoption = args?['searchAdoption'] ?? true;
    final searchMissing = args?['searchMissing'] ?? true;

    return Scaffold(
      appBar: const DefaultHeader(),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('adopters_post').snapshots(),
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

          final posts = snapshot.data!.docs.where((post) {
            final postType = post['type'];
            final postUserName = post['userName'];

            final matchesSearchText =
                searchText.isEmpty || postUserName.contains(searchText);
            final matchesAdoption =
                searchAdoption && postType == 'Pet Adoption';
            final matchesMissing = searchMissing && postType == 'Missing Pet';

            return matchesSearchText && (matchesAdoption || matchesMissing);
          }).toList();

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return FutureBuilder<String>(
                future: _getImageUrl(post['imagePath']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading image'));
                  }
                  final imageUrl = snapshot.data ?? '';

                  return HomePost(
                    postName: post['userName'],
                    postImage: imageUrl,
                    postPetName: post['petName'],
                    postType: post['type'],
                    postDescription: post['description'],
                    sellerUid: post['sellerUid'],
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: const AdoptersNavigationBar(),
    );
  }
}
