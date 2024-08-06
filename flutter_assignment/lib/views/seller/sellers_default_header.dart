import 'package:flutter/material.dart';
import 'package:flutter_assignment/routes.dart';
import 'package:flutter_assignment/views/seller/sellers_app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SellersDefaultHeader extends StatefulWidget
    implements PreferredSizeWidget {
  const SellersDefaultHeader({super.key});

  @override
  _SellersDefaultHeaderState createState() => _SellersDefaultHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SellersDefaultHeaderState extends State<SellersDefaultHeader> {
  bool hasNotification = false;
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      listenForUnreadNotifications();
    } else {
      print("No user is currently logged in.");
    }
  }

  void listenForUnreadNotifications() {
    if (user != null) {
      print("Listening for unread notifications for user: ${user!.uid}");
      FirebaseFirestore.instance
          .collection('notifications')
          .where('receiverId', isEqualTo: user!.uid)
          .where('isRead', isEqualTo: false)
          .snapshots()
          .listen((event) {
        if (event.docs.isNotEmpty) {
          print("Unread notifications found: ${event.docs.length}");
          setState(() {
            hasNotification = true;
          });
        } else {
          print("No unread notifications.");
          setState(() {
            hasNotification = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor
          .secondColor, // Ensure this is updated in sellers_app_color.dart
      automaticallyImplyLeading: false,
      title: const Text(
        "PawFect",
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
          fontFamily: AutofillHints.birthday,
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name !=
                    AppRoutes.sellerNotification) {
                  // Updated route
                  Navigator.pushNamed(
                      context, AppRoutes.sellerNotification); // Updated route
                }
              },
              icon: Image.asset("assets/bell.png"),
            ),
            if (hasNotification)
              Positioned(
                right: 11,
                top: 11,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: const Text(
                    '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
