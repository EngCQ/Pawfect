import 'package:flutter/material.dart';
import 'package:flutter_assignment/routes.dart';
import 'package:flutter_assignment/screens/adopter/adopters_notification.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_app_color.dart';

class DefaultHeader extends StatelessWidget implements PreferredSizeWidget {
  const DefaultHeader({super.key});

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
        IconButton(
          onPressed: () {
            if (ModalRoute.of(context)?.settings.name !=
                AppRoutes.adopterNotification) {
              Navigator.pushNamed(context, AppRoutes.adopterNotification);
            }
          },
          icon: Image.asset("lib/images/bell.png"),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
