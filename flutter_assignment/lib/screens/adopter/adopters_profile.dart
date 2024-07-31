import 'package:flutter/material.dart';
import 'package:flutter_assignment/providers/user_provider.dart';
import 'package:flutter_assignment/routes.dart';
import 'package:flutter_assignment/screens/adopter/adopters_help.dart';
import 'package:flutter_assignment/screens/adopter/adopters_reminder.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_default_header.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_navigation_bar.dart';
import 'package:provider/provider.dart';

class AdoptersProfile extends StatelessWidget {
  AdoptersProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: const DefaultHeader(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 6.0, top: 10),
        children: [
          const SizedBox(height: 16),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/profile.png'), // Ensure correct asset path
                  child: const Icon(Icons.camera_alt,
                      size: 50, color: Colors.white),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.camera_alt,
                        size: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Name"),
            subtitle: const Text("name"), // Replace with dynamic name
            trailing: const Icon(Icons.edit),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text("Email"),
            subtitle:
                const Text("example@gmail.com"), // Replace with dynamic email
            trailing: const Icon(Icons.edit),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.alarm_on),
            title: const Text('Reminders'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              if (ModalRoute.of(context)?.settings.name !=
                  AppRoutes.adopterReminder) {
                Navigator.pushNamed(context, AppRoutes.adopterReminder);
              }
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              if (ModalRoute.of(context)?.settings.name !=
                  AppRoutes.adopterHelp) {
                Navigator.pushNamed(context, AppRoutes.adopterHelp);
              }
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await userProvider.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.signIn,
                (route) => false,
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const AdoptersNavigationBar(),
    );
  }
}
