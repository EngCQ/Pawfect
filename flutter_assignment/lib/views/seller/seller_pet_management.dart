import 'package:flutter/material.dart';
import 'package:flutter_assignment/viewmodels/seller/seller_viewpet_viewmodel.dart';
import 'package:flutter_assignment/viewmodels/user_authentication.dart';
import 'package:flutter_assignment/views/seller/seller_add_pet.dart';
import 'package:flutter_assignment/views/seller/seller_edit_pet.dart';
import 'package:flutter_assignment/views/seller/sellers_default_header.dart';
import 'package:flutter_assignment/views/seller/sellers_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerPetManagement extends StatefulWidget {
  const SellerPetManagement({super.key});

  @override
  SellerPetManagementState createState() => SellerPetManagementState();
}

class SellerPetManagementState extends State<SellerPetManagement> {
  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<UserAuthentication>(context);
    final sellerUid = userAuth.user?.uid ?? 'User';

    return ChangeNotifierProvider(
      create: (_) => PetViewModel(sellerUid: sellerUid), // Pass sellerUid to PetViewModel
      child: Consumer<PetViewModel>(
        builder: (context, viewModel, child) {
          Query petsQuery = viewModel.petsQuery;

          return Scaffold(
            appBar: const SellersDefaultHeader(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ToggleButtons(
                      isSelected: [viewModel.isNewPetSelected, !viewModel.isNewPetSelected],
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
                    Row(
                      children: [
                        //Text(userAuth.user!.uid),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddPet(sellerUid: sellerUid), // Pass sellerUid to AddPet
                              ),
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
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return const Center(child: Text('Error fetching data.'));
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
                              final petData = pet.data() as Map<String, dynamic>; // Access the data as a map
                              final petName = petData['petName'] ?? 'Unknown';
                              final petFee = petData['fee'] ?? 'Unknown';
                              final petSpecies = petData['species'] ?? 'Unknown';
                              final petId = pet.id;
                              final profileImage = petData['imageUrl'];
                              final bool isAvailable = petData['purpose'] == 'Adoption';
                              const double avatarRadius = 30;

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  leading: Stack(
                                    children: [
                                      profileImage != null
                                          ? CircleAvatar(
                                              backgroundImage: NetworkImage(profileImage),
                                              radius: avatarRadius,
                                            )
                                          : const CircleAvatar(
                                              backgroundImage: AssetImage('assets/default_profile.png'),
                                              radius: avatarRadius,
                                            ),
                                      Positioned(
                                        right: 3,
                                        bottom: 0,
                                        child: Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: isAvailable ? Colors.green : Colors.red,
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
                                  title: Text(petName),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Fee: $petFee'),
                                      Text('Species: $petSpecies'),
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
                                              builder: (context) => EditPetScreen(petId: petId),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(context, viewModel, petId);
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
            bottomNavigationBar: const SellersNavigationBar(),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, PetViewModel viewModel, String petId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Pet'),
          content: const Text('Are you sure you want to delete this pet? This action cannot be undone.'),
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
