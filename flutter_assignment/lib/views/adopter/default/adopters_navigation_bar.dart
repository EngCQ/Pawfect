import 'package:flutter/material.dart';
import 'package:flutter_assignment/routes.dart';
import 'package:flutter_assignment/views/adopter/adopter_dashboard.dart';
import 'package:flutter_assignment/views/adopter/adopters_home.dart';
import 'package:flutter_assignment/views/adopter/adopters_profile.dart';
import 'package:flutter_assignment/views/adopter/default/adopters_app_color.dart';
import 'package:flutter_assignment/views/adopter/adopters_appointment.dart';
import 'package:flutter_assignment/views/adopter/adopters_favourite.dart';
import 'package:flutter_assignment/views/adopter/adopters_chat_list.dart';

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
                if (ModalRoute.of(context)?.settings.name != AdoptersHome()) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.adopterDashboard);
                }
              },
              icon: Image.asset("assets/home.png"),
            ),
          ),
          Transform.scale(
            scale: 1,
            child: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name !=
                    AdoptersFavourite) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.adopterFavourite);
                }
              },
              icon: Image.asset("assets/favourite.png"),
            ),
          ),
          Transform.scale(
            scale: 1,
            child: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name !=
                    AdoptersAppointment) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.adopterAppointment);
                }
              },
              icon: Image.asset("assets/calender.png"),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != AdoptersChatList) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.adopterChatList);
                }
              },
              icon: Image.asset("assets/chat.png"),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != AdoptersProfile) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.adopterProfile);
                }
              },
              icon: Image.asset("assets/profile.png"),
            ),
          ),
        ],
      ),
    );
  }
}
