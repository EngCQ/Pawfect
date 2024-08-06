import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String uid;
  final String bookingsId;
  final String date;
  final String description;
  final String fee;
  final String? imageUrl;
  final String location;
  final String notes;
  final String petName;
  final String purpose;
  final String sellerUid;
  final String phoneNumber;
  final String species;
  final String time;

  Booking({
    required this.uid,
    required this.bookingsId,
    required this.date,
    required this.description,
    required this.fee,
    this.imageUrl,
    required this.location,
    required this.notes,
    required this.petName,
    required this.purpose,
    required this.sellerUid,
    required this.phoneNumber,
    required this.species,
    required this.time,
  });

  // Factory constructor to create a Booking from Firestore document snapshot
  factory Booking.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Booking(
      uid: data['uid'] ?? '',
      bookingsId: data['bookingsId'] ?? '',
      date: data['postDate'] ?? '',
      description: data['postDescription'] ?? '',
      fee: data['fee'] ?? '',
      imageUrl: data['postImage'],
      location: data['location'] ?? '',
      notes: data['notes'] ?? '',
      petName: data['postPetName'] ?? '',
      purpose: data['postPurpose'] ?? '',
      sellerUid: data['sellerUid'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      species: data['species'] ?? '',
      time: data['time'] ?? '',
    );
  }

  // Method to convert Booking object to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'bookingsId': bookingsId,
      'postDate': date,
      'postDescription': description,
      'fee': fee,
      'postImage': imageUrl,
      'location': location,
      'notes': notes,
      'postPetName': petName,
      'postPurpose': purpose,
      'sellerUid': sellerUid,
      'phoneNumber': phoneNumber,
      'species': species,
      'time': time,
    };
  }
}
