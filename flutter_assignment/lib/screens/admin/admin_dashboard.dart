import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/theme_provider.dart';
import '/providers/user_provider.dart';
import '/routes.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0583CB),
        title: const Text('Dashboard'),
        actions: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF0583CB),
              ),
              child: Center(
                child: Image.asset(
                  'assets/logo.png', // Replace with your logo asset path
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.adminDashboard);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User Management'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.adminUserManagement);
              },
            ),
            ListTile(
              leading: const Icon(Icons.pets),
              title: const Text('Pet Management'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.adminPetManagement);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Appointment Management'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.adminAppoManagement);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedbacks'),
              onTap: () {
                // Navigate to Feedbacks page
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () async {
                await userProvider.signOut();
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signIn, (route) => false);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<UserProvider>(
                  builder: (context, provider, child) {
                    if (provider.userDetails == null) {
                      provider.fetchUserDetails();
                      return const CircularProgressIndicator();
                    } else {
                      return Text(
                        "Hello, ${provider.userDetails!['fullName']}",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Navigate to settings or any other action
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const DashboardCard(
              title: 'Total Users:',
              chartPlaceholder: Icons.show_chart,
            ),
            const DashboardCard(
              title: 'Total Pets Added:',
              chartPlaceholder: Icons.pie_chart,
            ),
            const DashboardCard(
              title: 'Total Appointments:',
              chartPlaceholder: Icons.show_chart,
            ),
            const DashboardCard(
              title: 'Total Feedbacks:',
              chartPlaceholder: Icons.pie_chart,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle create report
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0583CB),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'CREATE REPORT',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData chartPlaceholder;

  const DashboardCard({
    super.key,
    required this.title,
    required this.chartPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Placeholder(
                    fallbackHeight: 50,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              chartPlaceholder,
              size: 50,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}
