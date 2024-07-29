import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';

class AdoptersChat extends StatefulWidget {
  final String userId;
  final String userName;
  final String userImage;

  const AdoptersChat({
    super.key,
    required this.userId,
    required this.userName,
    required this.userImage,
  });

  @override
  _AdoptersChatState createState() => _AdoptersChatState();
}

class _AdoptersChatState extends State<AdoptersChat> {
  final currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Optionally, you can handle token updates or FCM registration here
    // e.g., saveTokenToDatabase(currentUser!.uid);
  }

  void sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    String chatId = currentUser!.uid.hashCode <= widget.userId.hashCode
        ? '${currentUser!.uid}_${widget.userId}'
        : '${widget.userId}_${currentUser!.uid}';

    await FirebaseFirestore.instance.collection('messages').add({
      'chatId': chatId,
      'senderId': currentUser!.uid,
      'receiverId': widget.userId,
      'timestamp': FieldValue.serverTimestamp(),
      'message': messageController.text,
      'isRead': false,
    });
    messageController.clear();
    await sendPushNotification(widget.userId, messageController.text);
  }

  Future<void> sendPushNotification(String receiverId, String message) async {
    // Fetch the receiver's FCM token from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    String? token = userDoc['fcmToken'];

    if (token != null) {
      // Construct the notification payload
      Map<String, dynamic> notification = {
        'to': token,
        'notification': {
          'title': 'New message from ${currentUser!.displayName}',
          'body': message,
        },
      };

      // Send the notification directly via FCM
      await FirebaseMessaging.instance.sendMessage(
        to: token,
        // notification: notification['notification'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String chatId = currentUser!.uid.hashCode <= widget.userId.hashCode
        ? '${currentUser!.uid}_${widget.userId}'
        : '${widget.userId}_${currentUser!.uid}';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.userImage.isNotEmpty
                  ? NetworkImage(widget.userImage)
                  : null,
              child: widget.userImage.isEmpty ? Icon(Icons.person) : null,
            ),
            SizedBox(width: 10),
            Text(widget.userName),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('chatId', isEqualTo: chatId)
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
                  return Center(child: Text('No messages'));
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe = message['senderId'] == currentUser!.uid;
                    var timestamp =
                        (message['timestamp'] as Timestamp?)?.toDate();
                    var formattedTime = timestamp != null
                        ? DateFormat('dd MMM yyyy, hh:mm a').format(timestamp)
                        : 'Sending...';

                    return ListTile(
                      title: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message'],
                                style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black),
                              ),
                              SizedBox(height: 5),
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isMe ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Message input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
