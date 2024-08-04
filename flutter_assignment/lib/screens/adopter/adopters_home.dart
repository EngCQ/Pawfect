import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'components/home_post.dart';
import 'default/adopters_default_header.dart';
import 'default/adopters_navigation_bar.dart';

class AdoptersHome extends StatefulWidget {
  const AdoptersHome({super.key});

  @override
  _AdoptersHomeState createState() => _AdoptersHomeState();
}

class _AdoptersHomeState extends State<AdoptersHome> {
  List<DocumentSnapshot> reminders = [];

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    fetchReminders();
  }

  Future<void> fetchReminders() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final now = tz.TZDateTime.now(tz.getLocation('Asia/Kuala_Lumpur'));
      final dayOfWeek = now.weekday; // 1 = Monday, 7 = Sunday

      final reminderSnapshots = await FirebaseFirestore.instance
          .collection('reminders')
          .where('uid', isEqualTo: currentUser.uid)
          .get();

      final List<DocumentSnapshot> matchingReminders = [];

      for (var reminder in reminderSnapshots.docs) {
        final repeatDays = List<String>.from(reminder['repeat']);
        final times = List<String>.from(reminder['times']);

        final dayMatches = repeatDays.contains([
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday'
        ][dayOfWeek % 7]);

        if (dayMatches) {
          for (var time in times) {
            final reminderTime = TimeOfDay(
              hour: int.parse(time.split(':')[0]),
              minute: int.parse(time.split(':')[1]),
            );
            final reminderDateTime = tz.TZDateTime(
              tz.getLocation('Asia/Kuala_Lumpur'),
              now.year,
              now.month,
              now.day,
              reminderTime.hour,
              reminderTime.minute,
            );

            if (reminderDateTime.isBefore(now) &&
                reminderDateTime.add(Duration(minutes: 5)).isAfter(now)) {
              matchingReminders.add(reminder);
              break;
            }
          }
        }
      }

      setState(() {
        reminders = matchingReminders;
      });
    }
  }

  Future<void> _dismissReminder(String reminderId) async {
    await FirebaseFirestore.instance
        .collection('reminders')
        .doc(reminderId)
        .delete();
    fetchReminders();
  }

  Future<String> _getImageUrl(String imagePath) async {
    try {
      return await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
    } catch (e) {
      print("Error fetching image URL: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final searchText = args?['searchText'] ?? '';
    final searchAdoption = args?['searchAdoption'] ?? true;
    final searchMissing = args?['searchMissing'] ?? true;

    return Scaffold(
      appBar: const DefaultHeader(),
      body: Column(
        children: [
          if (reminders.isNotEmpty)
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.orange[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: reminders.map((reminder) {
                  final reminderData = reminder.data() as Map<String, dynamic>;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reminderData['type'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text('Time for ${reminderData['type']}'),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => _dismissReminder(reminder.id),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('adopters_post')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No posts available'));
                }

                final posts = snapshot.data!.docs.where((post) {
                  final postPurpose = post['purpose'];
                  final postUserName = post['userName'];

                  final matchesSearchText =
                      searchText.isEmpty || postUserName.contains(searchText);
                  final matchesAdoption =
                      searchAdoption && postPurpose == 'Adoption';
                  final matchesMissing = searchMissing && postPurpose == 'Lost';

                  return matchesSearchText &&
                      (matchesAdoption || matchesMissing);
                }).toList();

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return FutureBuilder<String>(
                      future: _getImageUrl(post['imagePath']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading image'));
                        }
                        final imageUrl = snapshot.data ?? '';

                        return HomePost(
                          postName: post['userName'],
                          postImage: imageUrl,
                          postPetName: post['petName'],
                          postPurpose: post['purpose'],
                          postDescription: post['description'],
                          sellerUid: post['sellerUid'],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdoptersNavigationBar(),
    );
  }
}
