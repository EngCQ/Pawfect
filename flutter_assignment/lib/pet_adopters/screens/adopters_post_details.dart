import 'package:flutter/material.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_back_header.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_design.dart';

class AdoptersPostDetails extends StatelessWidget {
  const AdoptersPostDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackHeader(),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/pet_adopters/images/pets.jpeg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 360,
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                bottom: 20,
                top: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username',
                    style: TextStyle(
                      fontSize: Design.descriptionTitleSize,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Design.descriptionDetailTopPadding,
                      bottom: 10,
                    ),
                    child: Text(
                      'bla bla',
                      style: TextStyle(
                        fontSize: Design.descriptionDetailSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Pet's Name",
                    style: TextStyle(
                      fontSize: Design.descriptionTitleSize,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Design.descriptionDetailTopPadding,
                      bottom: 10,
                    ),
                    child: Text(
                      'bla bla',
                      style: TextStyle(
                        fontSize: Design.descriptionDetailSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: Design.descriptionTitleSize,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Design.descriptionDetailTopPadding,
                      bottom: 10,
                    ),
                    child: Text(
                      'bla bla',
                      style: TextStyle(
                        fontSize: Design.descriptionDetailSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            iconSize: 30,
            color: Colors.yellow[800],
            icon: const Icon(Icons.star),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Added to Favourite"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          SizedBox(
            height: 40,
            width: 180,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdoptersPostDetails()),
                );
              },
              child: const Text(
                "Book",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
