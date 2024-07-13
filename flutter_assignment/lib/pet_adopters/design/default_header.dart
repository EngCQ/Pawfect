// default_header.dart
import 'package:flutter/material.dart';

class DefaultHeader extends StatelessWidget implements PreferredSizeWidget {
  const DefaultHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.cyan,
      title: const Text(
        "PawFect",
        style: TextStyle(
          color: Color.fromARGB(149, 100, 100, 157),
          fontSize: 30.0,
          fontFamily: AutofillHints.birthday,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            print("filter clicked");
          },
          icon: Image.asset("lib/pet_adopters/images/filter.png"),
        ),
        IconButton(
          onPressed: () {
            print("notification clicked");
          },
          icon: Image.asset("lib/pet_adopters/images/bell.png"),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
