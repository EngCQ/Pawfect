import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_authentication.dart';
import '../viewmodels/theme_provider.dart';
import '../routes.dart';

class DrawerAdmin extends StatelessWidget {
  final String currentRoute;

  const DrawerAdmin({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0583CB),
            ),
            child: Center(
              child: Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: currentRoute == AppRoutes.adminDashboard,
            selectedTileColor: Colors.black12,
            onTap: () {
              if (currentRoute != AppRoutes.adminDashboard) {
                Navigator.pushNamed(context, AppRoutes.adminDashboard);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User Management'),
            selected: currentRoute == AppRoutes.adminUserManagement,
            selectedTileColor: Colors.black12,
            onTap: () {
              if (currentRoute != AppRoutes.adminUserManagement) {
                Navigator.pushNamed(context, AppRoutes.adminUserManagement);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.pets),
            title: const Text('Pet Management'),
            selected: currentRoute == AppRoutes.adminPetManagement,
            selectedTileColor: Colors.black12,
            onTap: () {
              if (currentRoute != AppRoutes.adminPetManagement) {
                Navigator.pushNamed(context, AppRoutes.adminPetManagement);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Appointment Management'),
            selected: currentRoute == AppRoutes.adminAppoManagement,
            selectedTileColor: Colors.black12,
            onTap: () {
              if (currentRoute != AppRoutes.adminAppoManagement) {
                Navigator.pushNamed(context, AppRoutes.adminAppoManagement);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Feedbacks'),
            selected: currentRoute == AppRoutes.adminFeedbacks,
            selectedTileColor: Colors.black12,
            onTap: () {
              // Navigate to Feedbacks page
              if (currentRoute != AppRoutes.adminFeedbacks) {
                Navigator.pushNamed(context, AppRoutes.adminFeedbacks);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            secondary: const Icon(Icons.brightness_6),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () async {
              // Reset to light mode before signing out
              themeProvider.resetToLightMode();
              Provider.of<UserAuthentication>(context, listen: false).signOut();
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signIn, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
