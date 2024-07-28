import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/screens/adopter/adopters_chat.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_default_header.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdoptersChatList extends StatefulWidget {
  const AdoptersChatList({super.key});

  @override
  _AdoptersChatListState createState() => _AdoptersChatListState();
}

class _AdoptersChatListState extends State<AdoptersChatList> {
  String searchQuery = '';
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultHeader(),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          // Chat user list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var users = snapshot.data!.docs;
                var filteredUsers = users.where((user) {
                  var fullName = user['fullName'] as String? ?? '';
                  return fullName
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    var user = filteredUsers[index];
                    var fullName = user['fullName'] ?? 'Unknown';
                    var isOnline = user['isOnline'] ?? false;
                    var image = user['profileImage'] ?? '';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            image.isNotEmpty ? NetworkImage(image) : null,
                        child: image.isEmpty ? Icon(Icons.person) : null,
                      ),
                      title: Text(fullName),
                      subtitle: Text(isOnline ? 'Online' : 'Offline'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdoptersChat(
                              userId: user.id,
                              userName: fullName,
                              userImage: image,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdoptersNavigationBar(),
    );
  }
}
