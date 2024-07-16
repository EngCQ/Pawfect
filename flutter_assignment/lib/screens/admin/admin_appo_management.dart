import 'package:flutter/material.dart';
import 'package:flutter_assignment/routes.dart';
import 'package:provider/provider.dart';
import '/providers/theme_provider.dart';

class AdminAppoManagement extends StatefulWidget {
  const AdminAppoManagement({super.key});

  @override
  _AdminAppoManagementState createState() => _AdminAppoManagementState();
}

class _AdminAppoManagementState extends State<AdminAppoManagement> {
  bool isAdoptersSelected = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Mock data for demonstration
    final adopters = [
      {'id': '123456745', 'name': 'JohnDoe'},
      {'id': '392837453', 'name': 'JohneNig'},
    ];

    final petSellers = [
      {'id': '764573849', 'name': 'JaneDoe'},
      {'id': '098765432', 'name': 'DoeJane'},
    ];

    final currentUsers = isAdoptersSelected ? adopters : petSellers;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0583CB),
        title: const Text('Appoinment Management'),
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
                Navigator.pop(context);
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
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ToggleButtons(
              isSelected: [isAdoptersSelected, !isAdoptersSelected],
              onPressed: (index) {
                setState(() {
                  isAdoptersSelected = index == 0;
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Adopters'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Pet Sellers'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAdoptersSelected
                        ? 'Total Adopters:'
                        : 'Total Pet Sellers:',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.pie_chart, size: 50, color: Colors.black26),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/adminAddUser');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('ADD'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Handle search action
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount:
                    currentUsers.length, // Number of items in the current list
                itemBuilder: (context, index) {
                  final user = currentUsers[index];
                  final userName =
                      user['name'] ?? 'Unknown'; // Provide a default value
                  final userId = user['id'] ?? 'N/A'; // Provide a default value

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Text(
                          userName.substring(0, 2), // Display initials
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(userName), // Display user name
                      subtitle: Text(userId), // Display user ID
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Handle edit action
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Handle delete action
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
