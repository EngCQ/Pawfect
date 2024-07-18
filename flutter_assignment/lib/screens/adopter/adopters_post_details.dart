import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter_assignment/screens/adopter/adopters_booking_form_overlay.dart';
import 'default/adopters_back_header.dart';
import 'default/adopters_design.dart';

class AdoptersPostDetails extends StatefulWidget {
  final String postName;
  final String postImage;
  final String postPetName;
  final String postType;
  final String postDescription;
  final String postSellerUid;

  const AdoptersPostDetails({
    Key? key,
    required this.postName,
    required this.postImage,
    required this.postPetName,
    required this.postType,
    required this.postDescription,
    required this.postSellerUid,
  }) : super(key: key);

  Future<void> saveToFavorites(BuildContext context) async {
    try {
      CollectionReference favoritesCollection =
          FirebaseFirestore.instance.collection('favorites');

      String? uid = FirebaseAuth.instance.currentUser?.uid;

      await favoritesCollection.add({
        'uid': uid,
        'postSellerUid': postSellerUid,
        'postName': postName,
        'postImage': postImage,
        'postPetName': postPetName,
        'postType': postType,
        'postDescription': postDescription,
        'timestamp': FieldValue.serverTimestamp(),
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
          SingleChildScrollView(
            child: Column(
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
                  color: Colors.blue,
                  padding: const EdgeInsets.all(10),
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
              ],
            ),
          ),
          if (showBookingForm)
            BookingFormOverlay(
              onClose: () {
                setState(() {
                  showBookingForm = false;
                });
              },
              postName: widget.postName,
              postImage: widget.postImage,
              postPetName: widget.postPetName,
              postType: widget.postType,
              postDescription: widget.postDescription,
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
                  backgroundColor: Colors.red,
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
