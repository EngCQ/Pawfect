import 'dart:ui';

class BookingModel {
  final String bookingId;
  final String image;
  final String name;
  final String date;
  final String time;
  final String phoneNumber;
  final String notes;
  final String postType;
  final String postDescription;
  final Color cardColor;

  BookingModel({
    required this.bookingId,
    required this.image,
    required this.name,
    required this.date,
    required this.time,
    required this.phoneNumber,
    required this.notes,
    required this.postType,
    required this.postDescription,
    required this.cardColor,
  });

  // Convert BookingModel to/from JSON if necessary
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['bookingId'],
      image: json['image'],
      name: json['name'],
      date: json['date'],
      time: json['time'],
      phoneNumber: json['phoneNumber'],
      notes: json['notes'],
      postType: json['postType'],
      postDescription: json['postDescription'],
      cardColor: Color(int.parse(json['cardColor'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'image': image,
      'name': name,
      'date': date,
      'time': time,
      'phoneNumber': phoneNumber,
      'notes': notes,
      'postType': postType,
      'postDescription': postDescription,
      'cardColor': cardColor.value.toString(),
    };
  }
}
