import 'package:flutter/material.dart';
import 'package:flutter_assignment/viewmodels/admin/pet_management/admin_viewpet_viewmodel.dart';
import 'package:flutter_assignment/views/admin/admin_edit_pet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_assignment/widgets/drawer_admin.dart';
import 'package:flutter_assignment/viewmodels/user_authentication.dart';
import 'package:flutter_assignment/views/admin/admin_pick_seller_pet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminPetManagement extends StatefulWidget {
  const AdminPetManagement({super.key});

  @override
  AdminPetManagementState createState() => AdminPetManagementState();
}

class AdminPetManagementState extends State<AdminPetManagement> {
  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<UserAuthentication>(context);
    final userEmail = userAuth.user?.email ?? 'User';

    return ChangeNotifierProvider(
      create: (_) => AdminPetViewModel(),
      child: Consumer<AdminPetViewModel>(
        builder: (context, viewModel, child) {
          CollectionReference petsRef = viewModel.petsRef;
          Query petsQuery = viewModel.petsQuery;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF0583CB),
              title: const Text('Pets'),
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
            drawer: const DrawerAdmin(currentRoute: '/adminPetManagement'),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ToggleButtons(
                      isSelected: [
                        viewModel.isNewPetSelected,
                        !viewModel.isNewPetSelected
                      ],
                      onPressed: (index) {
                        viewModel.togglePetSelection(index);
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Adoption Pets'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Lost Pets'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder<QuerySnapshot>(
                      stream: petsRef.snapshots(),
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

                        final pets = snapshot.data?.docs ?? [];
                        int totalAdoptionPets = pets
                            .where((pet) => pet['purpose'] == 'Adoption')
                            .length;
                        int totalLostPets = pets
                            .where((pet) => pet['purpose'] == 'Lost')
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
                                  viewModel.isNewPetSelected
                                      ? 'Adoption Pets: $totalAdoptionPets'
                                      : 'Lost Pets: $totalLostPets',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                if (totalAdoptionPets + totalLostPets > 0)
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: PieChart(
                                      PieChartData(
                                        sections: [
                                          PieChartSectionData(
                                            color: Colors.blue,
                                            value: totalAdoptionPets.toDouble(),
                                            title: 'Adoption',
                                            radius: 50,
                                            titleStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          PieChartSectionData(
                                            color: Colors.orange,
                                            value: totalLostPets.toDouble(),
                                            title: 'Lost',
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
                          onPressed: () async {
                            final selectedSeller = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdminSelectSellerForPetScreen(),
                              ),
                            );

                            if (selectedSeller != null) {
                              Navigator.pushNamed(
                                context,
                                '/adminAddPet',
                                arguments: selectedSeller['uid'],
                              );
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('ADD'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: viewModel.searchController,
                            decoration: InputDecoration(
                              hintText: 'Search',
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
                        stream: petsQuery.snapshots(),
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

                          final pets = snapshot.data?.docs ?? [];

                          final filteredPets = viewModel.getFilteredPets(pets);

                          if (filteredPets.isEmpty) {
                            return const Center(child: Text('No pets found.'));
                          }

                          return ListView.builder(
                            itemCount: filteredPets.length,
                            itemBuilder: (context, index) {
                              final pet = filteredPets[index];
                              final petData = pet.data() as Map<String,
                                  dynamic>; // Access the data as a map
                              final petName = petData['petName'] ?? 'Unknown';
                              final petFee = petData['fee'] ?? 'Unknown';
                              final petSpecies =
                                  petData['species'] ?? 'Unknown';
                              final petId = pet.id;
                              final profileImage = petData['imageUrl'];
                              const double avatarRadius = 30;

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
                                          : const CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/pet_icon.png'),
                                              radius: avatarRadius,
                                            ),
                                      Positioned(
                                        right: 3,
                                        bottom: 0,
                                        child: Container(
                                          width: 15,
                                          height: 15,
                                          // decoration: BoxDecoration(
                                          //   color: isAvailable ? Colors.green : Colors.red,
                                          //   shape: BoxShape.circle,
                                          //   border: Border.all(
                                          //     color: Colors.white,
                                          //     width: 2,
                                          //   ),
                                          // ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: Text(petName),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Species: $petSpecies'),
                                      //Text('ID: $petId'),
                                      Text('Fee (RM): $petFee'),
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
                                                  AdminEditPetScreen(
                                                      petId: petId),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(
                                              context, viewModel, petId);
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

  void _showDeleteConfirmationDialog(
      BuildContext context, AdminPetViewModel viewModel, String petId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Pet'),
          content: const Text(
              'Are you sure you want to delete this pet? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await viewModel.deletePet(petId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
