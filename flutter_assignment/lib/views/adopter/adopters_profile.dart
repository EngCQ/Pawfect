import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_assignment/routes.dart';
import 'package:flutter_assignment/viewmodels/user_authentication.dart';
import 'package:flutter_assignment/views/adopter/default/adopters_default_header.dart';
import 'package:flutter_assignment/views/adopter/default/adopters_navigation_bar.dart';

class AdoptersProfile extends StatelessWidget {
  AdoptersProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserAuthentication>(context);
    final userDetails = userProvider.userDetails ?? {};
    final userId = userDetails['uid'] ?? 'unknown_id'; // Ensure this gets the actual user ID
    final userName = userDetails['fullName'] ?? 'User';
    final userEmail = userDetails['email'] ?? 'example@gmail.com';
    final profileImageUrl = userDetails['profileImage'] ?? 'assets/profile.png';

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
                  backgroundImage: profileImageUrl.startsWith('http')
                      ? NetworkImage(profileImageUrl)
                      : AssetImage(profileImageUrl) as ImageProvider,
                  child: profileImageUrl == 'assets/profile.png'
                      ? const Icon(Icons.camera_alt,
                          size: 100, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Name"),
            subtitle: Text(userName),
          ),
          const Divider(),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text("Email"),
            subtitle: Text(userEmail),
          ),
          const Divider(),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Update Profile'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.adopterEditProfile,
                arguments: {'userId': userId},
              );
            },
          ),
          const Divider(),
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
          const Divider(),
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
          const Divider(),
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
