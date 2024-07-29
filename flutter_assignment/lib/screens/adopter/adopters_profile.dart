import 'package:flutter/material.dart';
import 'package:flutter_assignment/routes.dart';
import 'package:flutter_assignment/screens/adopter/adopters_help.dart';
import 'package:flutter_assignment/screens/adopter/adopters_reminder.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_default_header.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_navigation_bar.dart';

class AdoptersProfile extends StatelessWidget {
  const AdoptersProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultHeader(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 6.0, top: 10),
        children: [
          SizedBox(height: 16),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('profile.png'),
              child: Icon(Icons.camera_alt, size: 50, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text("Name"),
            subtitle: Text("name"),
            trailing: Icon(Icons.edit),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.email),
            title: Text("Email"),
            subtitle: Text("example@gmail.com"),
            trailing: Icon(Icons.edit),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.alarm_on),
            title: Text('Reminders'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              if (ModalRoute.of(context)?.settings.name != AdoptersReminder) {
                Navigator.pushNamed(context, AppRoutes.adopterReminder);
              }
            },
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              if (ModalRoute.of(context)?.settings.name != AdoptersHelp) {
                Navigator.pushNamed(context, AppRoutes.adopterHelp);
              }
            },
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Navigate to Reminders page
            },
          ),
        ],
      ),
      bottomNavigationBar: AdoptersNavigationBar(),
    );
  }
}
