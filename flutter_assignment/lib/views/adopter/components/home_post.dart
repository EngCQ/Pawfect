import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
  final VoidCallback onFavorite;
  final VoidCallback onUnfavorite;
  final bool showBookButton;

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
    this.showBookButton = false,
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

      widget.onFavorite();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You need to be logged in to favorite posts')),
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
        await FirebaseFirestore.instance
            .collection('favorites')
            .doc(doc.id)
            .delete();
      }

      setState(() {
        isFavorite = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites')),
      );

      widget.onUnfavorite();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You need to be logged in to unfavorite posts')),
      );
    }
  }

  Future<void> _showBookingForm() async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    String? notes;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Book'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Text(
                        selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                            : 'Select Date',
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                      child: Text(
                        selectedTime != null
                            ? selectedTime!.format(context)
                            : 'Select Time',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        notes = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some notes';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a date')),
                        );
                        return;
                      }
                      if (selectedTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a time')),
                        );
                        return;
                      }

                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        final uid = user.uid;
                        await FirebaseFirestore.instance
                            .collection('bookings')
                            .add({
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
                          'date': selectedDate,
                          'time': selectedTime!.format(context),
                          'notes': notes,
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Booked successfully')),
                        );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'You need to be logged in to book posts')),
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
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
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                      onPressed:
                          isFavorite ? _removeFromFavorite : _addToFavorite,
                      child:
                          Text(isFavorite ? 'UNFAVOURITE' : 'ADD TO FAVOURITE'),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.showBookButton) ...[
              const Divider(),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _showBookingForm,
                child: const Text('BOOK'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
