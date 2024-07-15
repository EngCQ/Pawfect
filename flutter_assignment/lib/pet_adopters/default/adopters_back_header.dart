import 'package:flutter/material.dart';

class BackHeader extends StatelessWidget implements PreferredSizeWidget {
  const BackHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.cyan,
      automaticallyImplyLeading: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
