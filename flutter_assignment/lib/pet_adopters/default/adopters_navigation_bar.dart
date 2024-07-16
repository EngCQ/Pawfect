import 'package:flutter/material.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_app_color.dart';
import 'package:flutter_assignment/pet_adopters/screens/adopters_appointment.dart';
import 'package:flutter_assignment/pet_adopters/screens/adopters_favourite.dart';
import 'package:flutter_assignment/pet_adopters/screens/adopters_chat_list.dart';

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
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != '/home') {
                  Navigator.pushNamed(context, '/home');
                }
              },
              icon: Image.asset("lib/pet_adopters/images/home.png"),
            ),
          ),
          Transform.scale(
            scale: 1,
            child: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != '/favourites') {
                  Navigator.pushNamed(context, '/favourites');
                }
              },
              icon: Image.asset("lib/pet_adopters/images/favourite.png"),
            ),
          ),
          Transform.scale(
            scale: 1,
            child: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != '/appointments') {
                  Navigator.pushNamed(context, '/appointments');
                }
              },
              icon: Image.asset("lib/pet_adopters/images/calender.png"),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != '/chat') {
                  Navigator.pushNamed(context, '/chat');
                }
              },
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
