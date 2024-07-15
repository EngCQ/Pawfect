import 'package:flutter/material.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_back_header.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_default_header.dart';

class AdoptersNotification extends StatelessWidget {
  AdoptersNotification({super.key});

  final List<String> notificationTitle = [
    'Message from Jay',
    'Reminder',
  ];

  final List<String> notificationMessage = [
    'Hello there, When you want to meet?',
    'Feed your pet on today 7 am',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackHeader(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Notification',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
