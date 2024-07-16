import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GettingTestingData extends StatelessWidget {
  const GettingTestingData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopters Post'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('adopters_post').snapshots(),
        builder: (context, snapshot) {
          List<Row> postWidgets = [];
          if (snapshot.hasData) {
            final posts = snapshot.data?.docs.reversed.toList();
            for (var post in posts!) {
              final postWidget = Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(post['userName']),
                  Text(post['petName']),
                  Text(post['type']),
                ],
              );
              postWidgets.add(postWidget);
            }
          }

          return Expanded(
            child: ListView(
              children: postWidgets,
            ),
          );
        },
      ),
    );
  }
}
