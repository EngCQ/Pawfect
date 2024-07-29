import 'package:flutter/material.dart';
import 'package:flutter_assignment/routes.dart';
import 'package:flutter_assignment/screens/adopter/adopters_notification.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment/main.dart';

class DefaultHeader extends StatefulWidget implements PreferredSizeWidget {
  const DefaultHeader({super.key});

  @override
  _DefaultHeaderState createState() => _DefaultHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _DefaultHeaderState extends State<DefaultHeader> {
  bool hasNotification = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('notifications')
        .where('receiverUid',
            isEqualTo: 'USER_UID') // Replace with actual user UID
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
      backgroundColor: AppColor.secondColor,
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
        IconButton(
          onPressed: () {
            if (ModalRoute.of(context)?.settings.name !=
                AppRoutes.adopterFilter) {
              Navigator.pushNamed(context, AppRoutes.adopterFilter);
            }
          },
          icon: Image.asset("lib/images/filter.png"),
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name !=
                    AppRoutes.adopterNotification) {
                  Navigator.pushNamed(context, AppRoutes.adopterNotification);
                }
              },
              icon: Image.asset("lib/images/bell.png"),
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
