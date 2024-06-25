import 'package:flutter/material.dart';

//Setting the default color for the application
class AppColor {
  static Color primaryColor = const Color(0xff2DC378);
}

class Template extends StatelessWidget {
  const Template({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          "PawFect",
          style: TextStyle(
              color: Color.fromARGB(149, 100, 100, 157),
              fontSize: 30.0,
              fontFamily: AutofillHints.birthday),
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
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColor.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Transform.scale(
              scale: 0.75,
              child: IconButton(
                onPressed: () {},
                icon: Image.asset("lib/pet_adopters/images/home.png"),
              ),
            ),
            Transform.scale(
              scale: 1,
              child: IconButton(
                onPressed: () {},
                icon: Image.asset("lib/pet_adopters/images/favourite.png"),
              ),
            ),
            Transform.scale(
              scale: 1,
              child: IconButton(
                onPressed: () {},
                icon: Image.asset("lib/pet_adopters/images/calender.png"),
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: IconButton(
                onPressed: () {},
                icon: Image.asset("lib/pet_adopters/images/chat.png"),
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: IconButton(
                onPressed: () {},
                icon: Image.asset("lib/pet_adopters/images/profile.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
