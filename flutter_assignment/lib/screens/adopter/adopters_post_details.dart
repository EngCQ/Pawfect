import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment/screens/adopter/adopters_booking_form_overlay.dart';
import 'package:flutter_assignment/screens/adopter/adopters_chat.dart';
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

  @override
  _AdoptersPostDetailsState createState() => _AdoptersPostDetailsState();
}

class _AdoptersPostDetailsState extends State<AdoptersPostDetails> {
  bool isFavorited = false;
  bool showBookingForm = false;
  String? favoriteDocId;

  @override
  void initState() {
    super.initState();
    checkIfFavorited();
  }

  Future<void> checkIfFavorited() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('favorites')
            .where('uid', isEqualTo: uid)
            .where('postSellerUid', isEqualTo: widget.postSellerUid)
            .where('postName', isEqualTo: widget.postName)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            isFavorited = true;
            favoriteDocId = querySnapshot.docs.first.id;
          });
        } else {
          setState(() {
            isFavorited = false;
            favoriteDocId = null;
          });
        }
      }
    } catch (e) {
      print('Error checking favorites: $e');
    }
  }

  Future<void> saveToFavorites(BuildContext context) async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('favorites').add({
        'uid': uid,
        'postSellerUid': widget.postSellerUid,
        'postName': widget.postName,
        'postImage': widget.postImage,
        'postPetName': widget.postPetName,
        'postType': widget.postType,
        'postDescription': widget.postDescription,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        isFavorited = true;
        favoriteDocId = docRef.id;
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

  Future<void> removeFromFavorites(BuildContext context) async {
    try {
      if (favoriteDocId != null) {
        await FirebaseFirestore.instance
            .collection('favorites')
            .doc(favoriteDocId)
            .delete();

        setState(() {
          isFavorited = false;
          favoriteDocId = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from Favorites'),
          ),
        );
      }
    } catch (e) {
      print('Error removing from favorites: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove from favorites: $e'),
        ),
      );
    }
  }

  void contactSeller(BuildContext context) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.postSellerUid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        String userName = userData['fullName'] ?? 'Unknown';
        String userImage = userData['profileImage'] ?? '';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdoptersChat(
              userId: widget.postSellerUid,
              userName: userName,
              userImage: userImage,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found'),
          ),
        );
      }
    } catch (e) {
      print('Error contacting seller: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to contact seller: $e'),
        ),
      );
    }
  }

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
            onPressed: () async {
              if (isFavorited) {
                await removeFromFavorites(context);
              } else {
                await saveToFavorites(context);
              }
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
                onPressed: () {
                  contactSeller(context);
                },
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
