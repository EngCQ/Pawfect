import 'package:flutter/material.dart';

class BackHeader extends StatelessWidget implements PreferredSizeWidget {
  const BackHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
