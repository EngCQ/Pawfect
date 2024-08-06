import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assignment/views/seller/sellers_back_header.dart';
import 'package:flutter_assignment/views/seller/sellers_chat.dart';

class SellersNotification extends StatelessWidget {
  SellersNotification({super.key});

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print('Error updating notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: const SellersBackHeader(), // Updated to Seller's back header
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notification',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .where('receiverId', isEqualTo: currentUser!.uid)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No notifications'));
                    }

                    var notifications = snapshot.data!.docs;
                    // ignore: unused_local_variable
                    bool hasUnreadNotifications = notifications
                        .any((notification) => !notification['isRead']);

                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        var notification = notifications[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 1),
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(notification['senderName']),
                            subtitle: Text(notification['message']),
                            trailing: !notification['isRead']
                                ? Icon(Icons.fiber_manual_record, color: Colors.red)
                                : null,
                            onTap: () async {
                              // Mark notification as read
                              await markNotificationAsRead(notification.id);

                              // Navigate to chat
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SellersChat( // Updated to Seller's chat
                                    userId: notification['senderId'],
                                    userName: notification['senderName'],
                                    userImage: '', // Add the user image if available
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
