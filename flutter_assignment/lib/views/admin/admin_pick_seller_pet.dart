import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_assignment/views/admin/admin_add_pet.dart';

class AdminSelectSellerForPetScreen extends StatefulWidget {
  const AdminSelectSellerForPetScreen({super.key});

  @override
  SelectSellerScreenState createState() => SelectSellerScreenState();
}

class SelectSellerScreenState extends State<AdminSelectSellerForPetScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> sellers = [];
  List<Map<String, String>> filteredSellers = [];
  Map<String, String>? _selectedSeller;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchSellers();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterSellers(_searchController.text);
  }

  void _filterSellers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSellers = sellers;
      } else {
        filteredSellers = sellers.where((seller) {
          final fullName = seller['fullName']!.toLowerCase();
          final uid = seller['uid']!.toLowerCase();
          final searchLower = query.toLowerCase();
          return fullName.contains(searchLower) || uid.contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> _fetchSellers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Seller')
        .get();

    final List<Map<String, String>> loadedSellers = querySnapshot.docs.map((doc) {
      return {
        'uid': doc['uid'] as String,
        'fullName': doc['fullName'] as String,
      };
    }).toList();

    setState(() {
      sellers = loadedSellers;
      filteredSellers = sellers; // Initialize filteredSellers with all sellers initially
    });
  }

  void _onSellerTap(Map<String, String> seller) {
    setState(() {
      _selectedSeller = seller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a seller from the list'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _filterSellers(_searchController.text);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredSellers.isEmpty
                  ? const Center(child: Text('No sellers found'))
                  : ListView.builder(
                      itemCount: filteredSellers.length,
                      itemBuilder: (context, index) {
                        final seller = filteredSellers[index];
                        final isSelected = _selectedSeller == seller;

                        return GestureDetector(
                          onTap: () => _onSellerTap(seller),
                          child: Card(
                            color: isSelected
                                ? const Color.fromARGB(255, 113, 240, 28).withOpacity(0.2)
                                : null,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  seller['fullName']!.substring(0, 2).toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(seller['fullName']!),
                              subtitle: Text(seller['uid']!),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: _selectedSeller == null
                  ? null
                  : () {
                      Navigator.pushNamed(
                        context,
                        '/adminAddPet',
                        arguments: _selectedSeller!['uid']!,
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
