import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_back_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdoptersReminder extends StatefulWidget {
  @override
  _AdoptersReminderState createState() => _AdoptersReminderState();
}

class _AdoptersReminderState extends State<AdoptersReminder> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showReminderForm(String reminderType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> repeatOptions = [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday'
        ];
        List<bool> repeatSelected =
            List.generate(repeatOptions.length, (index) => false);
        List<String> times = [];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Set Reminder for $reminderType'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(repeatOptions.length, (index) {
                        return CheckboxListTile(
                          title: Text(repeatOptions[index]),
                          value: repeatSelected[index],
                          onChanged: (bool? value) {
                            setState(() {
                              repeatSelected[index] = value ?? false;
                            });
                          },
                        );
                      }),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            times.add(picked.format(context));
                          });
                        }
                      },
                      child: Text('Add Time'),
                    ),
                    if (times.isNotEmpty) Text(times.join(', ')),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    if (repeatSelected.contains(true) && times.isNotEmpty) {
                      User? user = _auth.currentUser;
                      if (user != null) {
                        List<String> selectedRepeats = [];
                        for (int i = 0; i < repeatSelected.length; i++) {
                          if (repeatSelected[i]) {
                            selectedRepeats.add(repeatOptions[i]);
                          }
                        }
                        await _firestore.collection('reminders').add({
                          'type': reminderType,
                          'repeat': selectedRepeats,
                          'times': times,
                          'uid': user.uid,
                        });

                        // Add notification
                        await _firestore.collection('notifications').add({
                          'senderUid': user.uid,
                          'receiverUid': user.uid,
                          'title': reminderType,
                          'description': 'Remember to $reminderType your pet',
                          'time': DateTime
                              .now(), // Adjust this to the reminder time
                        });

                        Navigator.of(context).pop();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Please select at least one repeat option and one time.'),
                        ),
                      );
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(String reminderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Reminder'),
          content: Text('Are you sure you want to delete this reminder?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _firestore
                    .collection('reminders')
                    .doc(reminderId)
                    .delete();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReminderContainer(String title) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('reminders')
          .where('uid', isEqualTo: _auth.currentUser?.uid)
          .where('type', isEqualTo: title)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final reminders = snapshot.data!.docs;
        List<Widget> reminderWidgets = [];

        for (var reminder in reminders) {
          final repeat = List.from(reminder['repeat']).join(', ');
          final times = List.from(reminder['times']).join(', ');
          reminderWidgets.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Repeat: $repeat'),
                Text('Time: $times'),
              ],
            ),
          );
        }

        return Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyle(fontSize: 18)),
                  Switch(
                    value: reminderWidgets.isNotEmpty,
                    onChanged: (bool value) {
                      if (value) {
                        _showReminderForm(title);
                      } else {
                        if (snapshot.data!.docs.isNotEmpty) {
                          _confirmDelete(snapshot.data!.docs[0].id);
                        }
                      }
                    },
                  ),
                ],
              ),
              ...reminderWidgets,
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackHeader(),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          const Text("Reminders",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildReminderContainer('Feeding'),
          _buildReminderContainer('Pet Walking'),
          _buildReminderContainer('Pet Health Check'),
        ],
      ),
    );
  }
}
