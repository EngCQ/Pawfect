import 'package:flutter/widgets.dart';

class Design {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double descriptionTitleSize = 20;
  static double descriptionDetailSize = 15;
  static double descriptionDetailTopPadding = 5;
}
