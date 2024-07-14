import 'package:flutter/material.dart';
import 'package:flutter_assignment/pet_adopters/screens/adopters_post_details.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_design.dart';

class HomePost extends StatelessWidget {
  final String postName;
  final String postImage;

  const HomePost({super.key, required this.postName, required this.postImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(postImage),
            fit: BoxFit.fill, // Adjust the fit based on your needs
          ),
          color: Colors.deepPurple, // Fallback color if image fails to load
        ),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdoptersPostDetails()),
                );
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.black.withOpacity(0.5),
                child: Text(
                  postName,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 380,
                padding: const EdgeInsets.all(10),
                color: Colors.blue.withOpacity(0.5),
                child: const Text(
                  'Second Container',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
