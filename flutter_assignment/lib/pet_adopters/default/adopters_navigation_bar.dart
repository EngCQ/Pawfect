import 'package:flutter/material.dart';
import "package:flutter_assignment/pet_adopters/default/adopters_app_color.dart";
import "package:flutter_assignment/pet_adopters/screens/adopters_favourite.dart";

class AdoptersNavigationBar extends StatelessWidget {
  const AdoptersNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Favourite()));
              },
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
    );
  }
}
