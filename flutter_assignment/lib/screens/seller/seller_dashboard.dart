import 'package:flutter/material.dart';

class SellerDashboard extends StatelessWidget {
  const SellerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Seller Dashboard!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}