import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String feedbackId;
  final String feedback;
  final String purpose;
  final Timestamp timestamp;
  final String uid;

  String? userName;
  String? userEmail;

  FeedbackModel({
    required this.feedbackId,
    required this.feedback,
    required this.purpose,
    required this.timestamp,
    required this.uid,
    this.userName,
    this.userEmail,
  });

  factory FeedbackModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeedbackModel(
      feedbackId: doc.id,
      feedback: data['feedback'] ?? '',
      purpose: data['purpose'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      uid: data['uid'] ?? '',
    );
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        userName = userData['fullName'] ?? 'Unknown';
        userEmail = userData['email'] ?? 'Unknown';
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'feedbackId': feedbackId,
      'feedback': feedback,
      'purpose': purpose,
      'timestamp': timestamp,
      'uid': uid,
      'userName': userName,
      'userEmail': userEmail,
    };
  }
}
