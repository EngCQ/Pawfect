import 'package:flutter/material.dart';
import 'package:flutter_assignment/views/adopter/default/adopters_app_color.dart';

class SellersBackHeader extends StatelessWidget implements PreferredSizeWidget {
  const SellersBackHeader({Key? key});

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
