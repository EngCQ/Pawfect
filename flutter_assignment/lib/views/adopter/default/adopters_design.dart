import 'package:flutter/widgets.dart';

class Design {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

//page title
  static double pageTitle = 20.5;

//post
  static double descriptionTitleSize = 20;
  static double descriptionDetailSize = 17;
  static double descriptionDetailTopPadding = 5;

  static double filterTitle = 20;

//empty data page
  static double emptyPageSize = 30;
}
