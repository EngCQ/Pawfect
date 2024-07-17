import 'package:flutter/material.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_app_color.dart';

class BackHeader extends StatelessWidget implements PreferredSizeWidget {
  const BackHeader({Key? key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.secondColor,
      automaticallyImplyLeading: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
