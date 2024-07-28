import 'package:flutter/material.dart';

class AdoptersChat extends StatelessWidget {
  final String userId;

  const AdoptersChat({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Center(
        child: Text('Chat with user: $userId'),
      ),
    );
  }
}
