import 'package:flutter/material.dart';
import 'package:flutter_assignment/routes.dart';
import 'package:flutter_assignment/views/seller/sellers_app_color.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

class SellersDefaultHeader extends StatefulWidget implements PreferredSizeWidget { 
  const SellersDefaultHeader({super.key});

  @override
  _SellersDefaultHeaderState createState() => _SellersDefaultHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SellersDefaultHeaderState extends State<SellersDefaultHeader> {
  bool hasNotification = false;

  @override
  void initState() {
    super.initState();
    final userUid = 'USER_UID'; // Replace with logic to fetch actual seller UID
    FirebaseFirestore.instance
        .collection('notifications')
        .where('receiverUid', isEqualTo: userUid)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        setState(() {
          hasNotification = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.secondColor, // Ensure this is updated in sellers_app_color.dart
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
                    AppRoutes.sellerNotification) { // Updated route
                  Navigator.pushNamed(context, AppRoutes.sellerNotification); // Updated route
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
