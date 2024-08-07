import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment/routes.dart';

class AdminSelectAdopterForAppoScreen extends StatefulWidget {
  final String sellerUid;
  final String petUid;

  const AdminSelectAdopterForAppoScreen(
      {super.key, required this.sellerUid, required this.petUid});

  @override
  SelectAdopterAppoScreenState createState() => SelectAdopterAppoScreenState();
}

class SelectAdopterAppoScreenState
    extends State<AdminSelectAdopterForAppoScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> adopters = [];
  List<Map<String, String>> filteredAdopters = [];
  Map<String, String>? _selectedAdopter;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchAdopters();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterAdopters(_searchController.text);
  }

  void _filterAdopters(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAdopters = adopters;
      } else {
        filteredAdopters = adopters.where((adopter) {
          final fullName = adopter['fullName']!.toLowerCase();
          final uid = adopter['uid']!.toLowerCase();
          final searchLower = query.toLowerCase();
          return fullName.contains(searchLower) || uid.contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> _fetchAdopters() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Adopter')
        .get();

    final List<Map<String, String>> loadedAdopters =
        querySnapshot.docs.map((doc) {
      return {
        'uid': doc['uid'] as String,
        'fullName': doc['fullName'] as String,
      };
    }).toList();

    setState(() {
      adopters = loadedAdopters;
      filteredAdopters =
          adopters; // Initialize filteredAdopters with all adopters initially
    });
  }

  void _onAdopterTap(Map<String, String> adopter) {
    setState(() {
      _selectedAdopter = adopter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0583CB),
        //title: Text('Select an adopter for seller ${widget.sellerUid}'),
        title: const Text('Select an adopter for seller'),
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
                    _filterAdopters(_searchController.text);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredAdopters.isEmpty
                  ? const Center(child: Text('No adopters found'))
                  : ListView.builder(
                      itemCount: filteredAdopters.length,
                      itemBuilder: (context, index) {
                        final adopter = filteredAdopters[index];
                        final isSelected = _selectedAdopter == adopter;

                        return GestureDetector(
                          onTap: () => _onAdopterTap(adopter),
                          child: Card(
                            color: isSelected
                                ? const Color.fromARGB(255, 113, 240, 28)
                                    .withOpacity(0.2)
                                : null,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  adopter['fullName']!
                                      .substring(0, 2)
                                      .toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(adopter['fullName']!),
                              subtitle: Text(adopter['uid']!),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: _selectedAdopter == null
                  ? null
                  : () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.adminAddAppointment,
                        arguments: {
                          'sellerUid': widget.sellerUid,
                          'petUid': widget.petUid,
                          'adopterUid': _selectedAdopter!['uid']!,
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
