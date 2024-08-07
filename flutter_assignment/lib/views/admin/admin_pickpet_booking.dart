import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment/routes.dart';

class AdminSelectPetForAppoScreen extends StatefulWidget {
  final String sellerUid;

  const AdminSelectPetForAppoScreen({super.key, required this.sellerUid});

  @override
  SelectPetForAppoScreenState createState() => SelectPetForAppoScreenState();
}

class SelectPetForAppoScreenState extends State<AdminSelectPetForAppoScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> pets = [];
  List<Map<String, String>> filteredPets = [];
  Map<String, String>? _selectedPet;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchPets();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterPets(_searchController.text);
  }

  void _filterPets(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPets = pets;
      } else {
        filteredPets = pets.where((pet) {
          final petName = pet['petName']!.toLowerCase();
          final uid = pet['uid']!.toLowerCase();
          final searchLower = query.toLowerCase();
          return petName.contains(searchLower) || uid.contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> _fetchPets() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('pets')
          .where('sellerUid', isEqualTo: widget.sellerUid)
          .get();

      final List<Map<String, String>> loadedPets = querySnapshot.docs.map((doc) {
        print('Fetched pet: ${doc.data()}'); // Logging
        return {
          'uid': doc.id, // Use doc.id for the document ID
          'petName': doc['petName'] as String,
        };
      }).toList();

      setState(() {
        pets = loadedPets;
        filteredPets = pets; // Initialize filteredPets with all pets initially
      });

      print('Loaded pets: $loadedPets'); // Logging
    } catch (e) {
      print('Error fetching pets: $e'); // Error logging
    }
  }

  void _onPetTap(Map<String, String> pet) {
    setState(() {
      _selectedPet = pet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0583CB),
        title: const Text('Select a pet from the list'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text(
            //   'Selected Seller ID: ${widget.sellerUid}',
            //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _filterPets(_searchController.text);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredPets.isEmpty
                  ? const Center(child: Text('No pets found'))
                  : ListView.builder(
                      itemCount: filteredPets.length,
                      itemBuilder: (context, index) {
                        final pet = filteredPets[index];
                        final isSelected = _selectedPet == pet;

                        return GestureDetector(
                          onTap: () => _onPetTap(pet),
                          child: Card(
                            color: isSelected
                                ? const Color.fromARGB(255, 113, 240, 28).withOpacity(0.2)
                                : null,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  pet['petName']!.substring(0, 2).toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(pet['petName']!),
                              subtitle: Text(pet['uid']!),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: _selectedPet == null
                  ? null
                  : () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.adminSelectAdopterAppointment,
                        arguments: {
                          'sellerUid': widget.sellerUid,
                          'petUid': _selectedPet!['uid']!,
                        },
                      );
                    },
              child: const Text('CONTINUE'),
            ),
          ],
        ),
      ),
    );
  }
}
