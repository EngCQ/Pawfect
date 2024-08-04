import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String role;
  final String location;
  final String? profileImage;
  final bool isOnline;
  final DateTime? lastSeen;
  final String? phoneNumber;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    required this.location,
    this.profileImage,
    required this.isOnline,
    this.lastSeen,
    this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'role': role,
      'location': location,
      'profileImage': profileImage,
      'isOnline': isOnline,
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
      'phoneNumber': phoneNumber,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fullName: map['fullName'],
      role: map['role'],
      location: map['location'],
      profileImage: map['profileImage'],
      isOnline: map['isOnline'],
      lastSeen: map['lastSeen'] != null ? (map['lastSeen'] as Timestamp).toDate() : null,
      phoneNumber: map['phoneNumber'],
    );
  }
}
