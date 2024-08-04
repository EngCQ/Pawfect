import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePost extends StatefulWidget {
  final String postName;
  final String postImage;
  final String postPetName;
  final String postPurpose;
  final String postDescription;
  final String sellerUid;
  final String location;
  final String species;
  final String fee;
  final VoidCallback onFavorite; // Callback for favoriting
  final VoidCallback onUnfavorite; // Callback for unfavoriting
  final bool showBookButton; // Control whether to show the Book button

  const HomePost({
    super.key,
    required this.postName,
    required this.postImage,
    required this.postPetName,
    required this.postPurpose,
    required this.postDescription,
    required this.sellerUid,
    required this.location,
    required this.species,
    required this.fee,
    required this.onFavorite,
    required this.onUnfavorite,
    this.showBookButton = false, // Default to not show the Book button
  });

  @override
  _HomePostState createState() => _HomePostState();
}

class _HomePostState extends State<HomePost> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('uid', isEqualTo: uid)
          .where('postName', isEqualTo: widget.postName)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          isFavorite = true;
        });
      }
    }
  }

  Future<void> _addToFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      await FirebaseFirestore.instance.collection('favorites').add({
        'uid': uid,
        'postName': widget.postName,
        'postImage': widget.postImage,
        'postPetName': widget.postPetName,
        'postPurpose': widget.postPurpose,
        'postDescription': widget.postDescription,
        'sellerUid': widget.sellerUid,
        'location': widget.location,
        'species': widget.species,
        'fee': widget.fee,
      });

      setState(() {
        isFavorite = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to favorites')),
      );

      // Notify parent widget to remove this post from the list
      widget.onFavorite();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be logged in to favorite posts')),
      );
    }
  }

  Future<void> _removeFromFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('uid', isEqualTo: uid)
          .where('postName', isEqualTo: widget.postName)
          .get();

      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance.collection('favorites').doc(doc.id).delete();
      }

      setState(() {
        isFavorite = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites')),
      );

      // Notify parent widget to remove this post from the list
      widget.onUnfavorite();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be logged in to unfavorite posts')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.postPetName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Purpose: ${widget.postPurpose}'),
                      const SizedBox(height: 4),
                      Text('Description: ${widget.postDescription}'),
                      const SizedBox(height: 4),
                      Text('Location: ${widget.location}'),
                      const SizedBox(height: 4),
                      Text('Species: ${widget.species}'),
                      const SizedBox(height: 4),
                      Text('Fee: ${widget.fee}'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Container(
                      width: 120,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: widget.postImage.isNotEmpty
                          ? Image.network(
                              widget.postImage,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/default_profile.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: isFavorite ? _removeFromFavorite : _addToFavorite,
                      child: Text(isFavorite ? 'UNFAVOURITE' : 'ADD TO FAVOURITE'),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.showBookButton) ...[
              const Divider(),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Handle the book action here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booked')),
                  );
                },
                child: const Text('BOOK'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
