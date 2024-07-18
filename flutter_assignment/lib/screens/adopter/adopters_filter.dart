import 'package:flutter/material.dart';
import 'package:flutter_assignment/providers/user_provider.dart';
import 'package:flutter_assignment/routes.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_app_color.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_back_header.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_design.dart';
import 'package:provider/provider.dart';

class AdoptersFilter extends StatefulWidget {
  const AdoptersFilter({Key? key}) : super(key: key);

  @override
  _AdoptersFilterState createState() => _AdoptersFilterState();
}

class _AdoptersFilterState extends State<AdoptersFilter> {
  bool adoptionChecked = true;
  bool missingChecked = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackHeader(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search and Filter',
              style: TextStyle(fontSize: Design.pageTitle),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search Username',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: adoptionChecked,
                    onChanged: (newBool) {
                      setState(() {
                        adoptionChecked = newBool ?? false;
                      });
                    },
                  ),
                ),
                Text(
                  "Adoption",
                  style: TextStyle(fontSize: Design.filterTitle),
                ),
              ],
            ),
            Row(
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: missingChecked,
                    onChanged: (newBool) {
                      setState(() {
                        missingChecked = newBool ?? false;
                      });
                    },
                  ),
                ),
                Text(
                  "Missing",
                  style: TextStyle(fontSize: Design.filterTitle),
                ),
              ],
            ),
            const SizedBox(height: 70),
            Center(
              child: SizedBox(
                width: 150, // Set the desired width
                height: 50, // Set the desired height
                child: ElevatedButton(
                  onPressed: () {
                    String searchAdoption = "";
                    String searchMissing = "";
                    String searchText = _searchController.text;
                    if (adoptionChecked) {
                      searchAdoption = "Pet Adoption";
                    }
                    if (missingChecked) {
                      searchMissing = "Missing Pet";
                    }
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.adopterDashboard);
                  },
                  child: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColor.secondColor, // Text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
