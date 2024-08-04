import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_assignment/widgets/drawer_admin.dart';
import 'package:flutter_assignment/viewmodels/user_authentication.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<UserAuthentication>(context);
    final userDetails = userAuth.userDetails ?? {};
    final userEmail = userDetails['email'] ?? 'User';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0583CB),
        title: const Text('Dashboard'),
        actions: [
          Row(
            children: [
              Text(
                  userEmail,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const DrawerAdmin(currentRoute: '/adminDashboard'), // Use the custom drawer widget
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          
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
              onPressed: () {},
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
