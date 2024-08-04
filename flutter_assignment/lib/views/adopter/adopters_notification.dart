import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assignment/views/adopter/adopters_chat.dart';
import 'package:flutter_assignment/views/adopter/default/adopters_back_header.dart';

class AdoptersNotification extends StatefulWidget {
  AdoptersNotification({super.key});

  @override
  _AdoptersNotificationState createState() => _AdoptersNotificationState();
}

class _AdoptersNotificationState extends State<AdoptersNotification> {
  Future<void> markNotificationAsRead(
      String notificationId, String senderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print('Error updating notification: $e');
    }

    try {
      await _markMessagesAsRead(senderId);
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> _markMessagesAsRead(String senderId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    String chatId = currentUser.uid.hashCode <= senderId.hashCode
        ? '${currentUser.uid}_${senderId}'
        : '${senderId}_${currentUser.uid}';

    var messageQuery = await FirebaseFirestore.instance
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .where('isRead', isEqualTo: false)
        .where('receiverId', isEqualTo: currentUser.uid)
        .get();

    for (var doc in messageQuery.docs) {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(doc.id)
          .update({'isRead': true});
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
        appBar: const BackHeader(),
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
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No notifications'));
                    }

                    var notifications = snapshot.data!.docs;
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
                                ? Icon(Icons.fiber_manual_record,
                                    color: Colors.red)
                                : null,
                            onTap: () async {
                              // Mark notification and messages as read
                              await markNotificationAsRead(
                                  notification.id, notification['senderId']);

                              // Navigate to chat
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdoptersChat(
                                    userId: notification['senderId'],
                                    userName: notification['senderName'],
                                    userImage:
                                        '', // Add the user image if available
                                  ),
                                ),
                              ).then((_) {
                                // Refresh the list when coming back from chat screen
                                setState(() {});
                              });
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
