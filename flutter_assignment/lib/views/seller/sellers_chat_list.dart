import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assignment/views/seller/sellers_chat.dart';
import 'package:flutter_assignment/views/seller/sellers_default_header.dart';
import 'package:flutter_assignment/views/seller/sellers_navigation_bar.dart';

class SellersChatList extends StatefulWidget {
  const SellersChatList({super.key});

  @override
  _SellersChatListState createState() => _SellersChatListState();
}

class _SellersChatListState extends State<SellersChatList> {
  String searchQuery = '';
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {}); // Trigger a rebuild to refresh unread status
  }

  @override
  void didUpdateWidget(SellersChatList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {}); // Trigger a rebuild to refresh unread status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SellersDefaultHeader(), // Updated to Seller's default header
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
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
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
                    var userId = user.id;

                    return FutureBuilder<bool>(
                      future: _hasUnreadMessages(userId),
                      builder: (context, snapshot) {
                        bool hasUnreadMessages = snapshot.data ?? false;

                        return ListTile(
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage: image.isNotEmpty
                                    ? NetworkImage(image)
                                    : null,
                                child: image.isEmpty ? const Icon(Icons.person) : null,
                              ),
                              if (hasUnreadMessages)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          title: Text(fullName),
                          subtitle: Text(isOnline ? 'Online' : 'Offline'),
                          onTap: () async {
                            // Mark messages as read
                            await _markMessagesAsRead(userId);
                            // Mark notifications as read
                            await _markNotificationsAsRead(userId);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellersChat( // Updated to Seller's chat
                                  userId: userId,
                                  userName: fullName,
                                  userImage: image,
                                ),
                              ),
                            ).then((_) {
                              // Refresh the list when coming back from chat screen
                              setState(() {});
                            });
                          },
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
      bottomNavigationBar: const SellersNavigationBar(), // Updated to Seller's navigation bar
    );
  }

  Future<bool> _hasUnreadMessages(String userId) async {
    if (currentUser == null) return false;

    String chatId = currentUser!.uid.hashCode <= userId.hashCode
        ? '${currentUser!.uid}_${userId}'
        : '${userId}_${currentUser!.uid}';

    var messageQuery = await FirebaseFirestore.instance
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .where('isRead', isEqualTo: false)
        .where('receiverId', isEqualTo: currentUser!.uid)
        .get();

    return messageQuery.docs.isNotEmpty;
  }

  Future<void> _markMessagesAsRead(String userId) async {
    if (currentUser == null) return;

    String chatId = currentUser!.uid.hashCode <= userId.hashCode
        ? '${currentUser!.uid}_${userId}'
        : '${userId}_${currentUser!.uid}';

    var messageQuery = await FirebaseFirestore.instance
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .where('isRead', isEqualTo: false)
        .where('receiverId', isEqualTo: currentUser!.uid)
        .get();

    for (var doc in messageQuery.docs) {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(doc.id)
          .update({
        'isRead': true,
      });
    }
  }

  Future<void> _markNotificationsAsRead(String userId) async {
    if (currentUser == null) return;

    var notificationQuery = await FirebaseFirestore.instance
        .collection('notifications')
        .where('receiverId', isEqualTo: currentUser!.uid)
        .where('senderId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in notificationQuery.docs) {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(doc.id)
          .update({
        'isRead': true,
      });
    }
  }
}
