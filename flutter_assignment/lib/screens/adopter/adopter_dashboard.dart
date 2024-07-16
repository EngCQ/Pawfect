import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/user_provider.dart';
import '/routes.dart';

class AdopterDashboard extends StatelessWidget {
  const AdopterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopter Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await userProvider.signOut();
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signIn, (route) => false);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to the Adopter Dashboard!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
