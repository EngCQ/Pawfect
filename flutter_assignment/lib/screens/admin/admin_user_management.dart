import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '/providers/theme_provider.dart';
import '/providers/user_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_assignment/routes.dart';
import 'package:flutter_assignment/screens/admin/admin_edit_user.dart';

class AdminUserManagement extends StatefulWidget {
  const AdminUserManagement({super.key});

  @override
  _AdminUserManagementState createState() => _AdminUserManagementState();
}

class _AdminUserManagementState extends State<AdminUserManagement> {
  bool isAdoptersSelected = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    // Get reference to Firestore collection based on selection
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    Query usersQuery = isAdoptersSelected
        ? usersRef.where('role', isEqualTo: 'Adopter')
        : usersRef.where('role', isEqualTo: 'Seller');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0583CB),
        title: const Text('User Management'),
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
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.adminDashboard);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User Management'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.pets),
              title: const Text('Pet Management'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.adminPetManagement);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Appointment Management'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.adminAppoManagement);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedbacks'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Feedbacks page
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () async {
                await userProvider.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.signIn, (route) => false);
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
            StreamBuilder<QuerySnapshot>(
              stream: usersRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data.'));
                }

                final users = snapshot.data?.docs ?? [];

                // Count the number of adopters and pet sellers
                int totalAdopters =
                    users.where((user) => user['role'] == 'Adopter').length;
                int totalPetSellers =
                    users.where((user) => user['role'] == 'Seller').length;

                return Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total ${isAdoptersSelected ? 'Adopters' : 'Pet Sellers'}: ${isAdoptersSelected ? totalAdopters : totalPetSellers}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      if (totalAdopters + totalPetSellers > 0)
                        SizedBox(
                          width: 100, // Adjust the width as needed
                          height: 100, // Adjust the height as needed
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  color: Colors.blue,
                                  value: totalAdopters.toDouble(),
                                  title: 'Adopters',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  badgePositionPercentageOffset: 1.2,
                                ),
                                PieChartSectionData(
                                  color: Colors.orange,
                                  value: totalPetSellers.toDouble(),
                                  title: 'Pet Sellers',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  badgePositionPercentageOffset: 1.2,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        const Text('No data available for the chart.'),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.adminAddUser);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('ADD'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name, email, or ID',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: usersQuery.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching data.'));
                  }

                  final users = snapshot.data?.docs ?? [];

                  // Filter the users list based on the search input
                  final filteredUsers = users.where((user) {
                    final fullName = user['fullName'].toString().toLowerCase();
                    final email = user['email'].toString().toLowerCase();
                    final userId = user['uid'].toString().toLowerCase();
                    final searchText = _searchController.text.toLowerCase();
                    return fullName.contains(searchText) ||
                        email.contains(searchText) ||
                        userId.contains(searchText);
                  }).toList();

                  if (filteredUsers.isEmpty) {
                    return const Center(
                      child: Text('No users found matching your search.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      final userName = user['fullName'] ?? 'Unknown';
                      final userId = user['uid'] ?? 'N/A';
                      final profileImage = user['profileImage'];
                      final bool isOnline = user['isOnline'] ?? false;
                      const double avatarRadius = 30; // Set the radius here

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Stack(
                            children: [
                              profileImage != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(profileImage),
                                      radius: avatarRadius,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: avatarRadius,
                                      child: Text(
                                        userName.isNotEmpty
                                            ? userName
                                                .substring(0, 2)
                                                .toUpperCase()
                                            : 'NA', // Display initials or 'NA' if name is empty
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                              Positioned(
                                right: 3,
                                bottom: 0,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: isOnline
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 223, 218, 217),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: Text(userName), // Display user name
                          subtitle: Text(userId), // Display user ID
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Navigate to edit screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AdminEditUser(userId: userId),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Show confirmation dialog
                                  _showDeleteConfirmationDialog(userId);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(), // Dismiss the dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Call delete user function here
                await _deleteUser(userId);
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }
}
