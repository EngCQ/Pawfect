import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_assignment/viewmodels/user_authentication.dart';
import 'components/home_post.dart';
import 'default/adopters_default_header.dart';
import 'default/adopters_navigation_bar.dart';

class AdoptersHome extends StatefulWidget {
  const AdoptersHome({super.key});

  @override
  _AdoptersHomeState createState() => _AdoptersHomeState();
}

class _AdoptersHomeState extends State<AdoptersHome> {
  List<DocumentSnapshot> posts = [];
  List<DocumentSnapshot> reminders = [];
  List<String> favoritePostNames = [];

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final userUid = Provider.of<UserAuthentication>(context, listen: false)
            .userDetails?['uid'] ??
        '';
    _getFavoritePostNames(userUid);
    fetchReminders(userUid);
  }

  Future<String> _getImageUrl(String imagePath) async {
    try {
      return await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
    } catch (e) {
      print("Error fetching image URL: $e");
      return '';
    }
  }

  Future<void> _getFavoritePostNames(String uid) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('uid', isEqualTo: uid)
        .get();

    setState(() {
      favoritePostNames =
          querySnapshot.docs.map((doc) => doc['postName'] as String).toList();
    });
  }

  Future<void> fetchReminders(String uid) async {
    final now = tz.TZDateTime.now(tz.getLocation('Asia/Kuala_Lumpur'));
    final dayOfWeek = now.weekday; // 1 = Monday, 7 = Sunday

    final reminderSnapshots = await FirebaseFirestore.instance
        .collection('reminders')
        .where('uid', isEqualTo: uid)
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
              reminderDateTime.add(const Duration(minutes: 5)).isAfter(now)) {
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

  Future<void> _dismissReminder(String reminderId) async {
    await FirebaseFirestore.instance
        .collection('reminders')
        .doc(reminderId)
        .delete();
    final userUid = Provider.of<UserAuthentication>(context, listen: false)
            .userDetails?['uid'] ??
        '';
    fetchReminders(userUid);
  }

  Future<void> _addFavoritePost(String postName, String uid) async {
    await FirebaseFirestore.instance.collection('favorites').add({
      'uid': uid,
      'postName': postName,
    });
    _getFavoritePostNames(uid); // Refresh favorite posts
  }

  void _removeFavoritePost(String postName, String uid) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('uid', isEqualTo: uid)
        .where('postName', isEqualTo: postName)
        .get();

    for (var doc in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('favorites')
          .doc(doc.id)
          .delete();
    }
    _getFavoritePostNames(uid);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final searchText = args?['searchText'] ?? '';
    final searchAdoption = args?['searchAdoption'] ?? true;
    final searchMissing = args?['searchMissing'] ?? true;

    final userDetails =
        Provider.of<UserAuthentication>(context).userDetails ?? {};
    final userEmail = userDetails['email'] ?? 'User';
    final userName = userDetails['fullName'] ?? 'User';
    final userUid = userDetails['uid'] ?? '';

    return Scaffold(
      appBar: const DefaultHeader(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome, $userName',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  userEmail,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          if (reminders.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
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
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text('Time for ${reminderData['type']}'),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _dismissReminder(reminder.id),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('pets').snapshots(),
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

                posts = snapshot.data!.docs.where((post) {
                  final postPurpose = post['purpose'];
                  final postUserName = post['petName'];

                  final matchesSearchText =
                      searchText.isEmpty || postUserName.contains(searchText);
                  final matchesAdoption =
                      searchAdoption && postPurpose == 'Adoption';
                  final matchesMissing = searchMissing && postPurpose == 'Lost';
                  final isFavorite = favoritePostNames.contains(postUserName);

                  return matchesSearchText &&
                      (matchesAdoption || matchesMissing) &&
                      !isFavorite;
                }).toList();

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final imageUrl = post['imageUrl'] ?? '';

                    return HomePost(
                      postName: post['petName'],
                      postImage: imageUrl,
                      postPetName: post['petName'],
                      postPurpose: post['purpose'],
                      postDescription: post['description'],
                      sellerUid: post['sellerUid'],
                      location: post['location'],
                      species: post['species'],
                      fee: post['fee'],
                      onFavorite: () =>
                          _addFavoritePost(post['petName'], userUid),
                      onUnfavorite: () =>
                          _removeFavoritePost(post['petName'], userUid),
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
