import 'package:flutter/material.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_back_header.dart'; // Adjust import as per your file structure

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
    return WillPopScope(
      onWillPop: () async {
        // Handle pop behavior as needed
        return true; // Return true to allow popping
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
              for (var i = 0; i < notificationTitle.length; i++)
                Container(
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
                    title: Text(notificationTitle[i]),
                    subtitle: Text(notificationMessage[i]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
