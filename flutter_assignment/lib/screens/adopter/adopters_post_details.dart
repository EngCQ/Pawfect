import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter_assignment/screens/adopter/components/booking_form_overlay.dart';
import 'default/adopters_back_header.dart';
import 'default/adopters_design.dart';

class AdoptersPostDetails extends StatefulWidget {
  final String postName;
  final String postImage;
  final String postPetName;
  final String postType;
  final String postDescription;

  const AdoptersPostDetails({
    Key? key,
    required this.postName,
    required this.postImage,
    required this.postPetName,
    required this.postType,
    required this.postDescription,
  }) : super(key: key);

  Future<void> saveToFavorites(BuildContext context) async {
    try {
      // Reference to Firestore collection
      CollectionReference favoritesCollection =
          FirebaseFirestore.instance.collection('favorites');

      // Add document with post details
      await favoritesCollection.add({
        'postName': postName,
        'postImage': postImage,
        'postPetName': postPetName,
        'postType': postType,
        'postDescription': postDescription,
        'timestamp': FieldValue
            .serverTimestamp(), // Optional: Timestamp of when it was added
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to Favorites'),
        ),
      );
    } catch (e) {
      print('Error adding to favorites: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to favorites: $e'),
        ),
      );
    }
  }

  @override
  _AdoptersPostDetailsState createState() => _AdoptersPostDetailsState();
}

class _AdoptersPostDetailsState extends State<AdoptersPostDetails> {
  bool isFavorited = false;
  bool showBookingForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackHeader(),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 330,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.postImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 300,
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
                        'Username: ${widget.postName}',
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
                          'Type: ${widget.postType}',
                          style: TextStyle(
                            fontSize: Design.descriptionTitleSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "Pet's Name: ${widget.postPetName}",
                        style: TextStyle(
                          fontSize: Design.descriptionTitleSize,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: Design.descriptionDetailTopPadding,
                        ),
                        child: Text(
                          'Description: ',
                          style: TextStyle(
                            fontSize: Design.descriptionTitleSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        widget.postDescription,
                        style: TextStyle(
                          fontSize: Design.descriptionDetailSize,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (showBookingForm)
            BookingFormOverlay(
              onClose: () {
                setState(() {
                  showBookingForm = false;
                });
              },
            ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            iconSize: 30,
            color: isFavorited ? Colors.yellow[800] : Colors.grey,
            icon: const Icon(Icons.star),
            onPressed: () {
              setState(() {
                isFavorited = !isFavorited;
              });

              // Save to favorites only when the button is pressed
              if (isFavorited) {
                widget.saveToFavorites(context);
              }

              String message =
                  isFavorited ? 'Added to Favorites' : 'Removed from Favorites';
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),

          // Conditionally show the ElevatedButton based on postType
          if (widget.postType == 'Pet Adoption')
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
                  setState(() {
                    showBookingForm = true;
                  });
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
          if (widget.postType != 'Pet Adoption')
            SizedBox(
              height: 40,
              width: 180,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Colors.red, // Example color for other types
                ),
                onPressed: () {},
                child: const Text(
                  "Contact",
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
