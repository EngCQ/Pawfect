import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_assignment/widgets/drawer_admin.dart';
import 'package:flutter_assignment/viewmodels/user_authentication.dart';
import 'package:flutter_assignment/viewmodels/admin/user_management/admin_userview_model.dart';
import 'package:flutter_assignment/views/admin/admin_add_user.dart';
import 'package:flutter_assignment/views/admin/admin_edit_user.dart';
import 'package:intl/intl.dart';

class AdminUserManagement extends StatefulWidget {
  const AdminUserManagement({super.key});

  @override
  AdminUserManagementState createState() => AdminUserManagementState();
}

class AdminUserManagementState extends State<AdminUserManagement> {
  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<UserAuthentication>(context);
    final userEmail = userAuth.user?.email ?? 'User';

    return ChangeNotifierProvider(
      create: (_) => AdminUserViewModel(),
      child: Consumer<AdminUserViewModel>(
        builder: (context, viewModel, child) {
          CollectionReference usersRef = viewModel.usersRef;
          Query usersQuery = viewModel.usersQuery;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF0583CB),
              title: const Text('Users'),
              actions: [
                Row(
                  children: [
                    Text(
                      userEmail,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
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
            drawer: const DrawerAdmin(currentRoute: '/adminUserManagement'),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ToggleButtons(
                      isSelected: [
                        viewModel.isAdoptersSelected,
                        !viewModel.isAdoptersSelected
                      ],
                      onPressed: (index) {
                        viewModel.toggleRoleSelection(index);
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error fetching data.'));
                        }

                        final users = snapshot.data?.docs ?? [];

                        int totalAdopters = users
                            .where((user) => user['role'] == 'Adopter')
                            .length;
                        int totalPetSellers = users
                            .where((user) => user['role'] == 'Seller')
                            .length;

                        return Material(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8.0),
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total ${viewModel.isAdoptersSelected ? 'Adopters' : 'Pet Sellers'}: ${viewModel.isAdoptersSelected ? totalAdopters : totalPetSellers}',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                if (totalAdopters + totalPetSellers > 0)
                                  SizedBox(
                                    width: 100,
                                    height: 100,
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  const Text(
                                      'No data available for the chart.'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AdminAddUser()), // Use MaterialPageRoute
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('ADD'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: viewModel.searchController,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: usersQuery.snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error fetching data.'));
                          }

                          final users = snapshot.data?.docs ?? [];
                          final filteredUsers =
                              viewModel.getFilteredUsers(users);

                          if (filteredUsers.isEmpty) {
                            return const Center(
                                child: Text(
                                    'No users found matching your search.'));
                          }

                          return ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              final usersEmail = user.email;
                              final userPhoneNumber = user.phoneNumber;
                              final userName = user.fullName;
                              final userId = user.uid;
                              final profileImage = user.profileImage;
                              final bool isOnline = user.isOnline;
                              final DateTime? lastSeen = user.lastSeen;
                              const double avatarRadius = 30;

                              // Format lastSeen as a string
                              String lastSeenString = lastSeen != null
                                  ? DateFormat.yMMMd().add_jm().format(lastSeen)
                                  : 'Never';

                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
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
                                  title: Text(userName),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Email: $usersEmail'),
                                      Text('Phone Number: $userPhoneNumber'),
                                      Text('Last seen: $lastSeenString'),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminEditUser(userId: userId),
                                            ),
                                          );
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
            ),
          );
        },
      ),
    );
  }
}
