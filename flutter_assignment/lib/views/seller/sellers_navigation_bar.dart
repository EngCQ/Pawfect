import 'package:flutter/material.dart';
import 'package:flutter_assignment/routes.dart';
import 'package:flutter_assignment/views/adopter/default/adopters_app_color.dart';
import 'package:flutter_assignment/views/seller/seller_pet_management.dart';
import 'package:flutter_assignment/views/seller/sellers_appointment.dart';
import 'package:flutter_assignment/views/seller/sellers_chat_list.dart';
import 'package:flutter_assignment/views/seller/sellers_home.dart';
import 'package:flutter_assignment/views/seller/sellers_profile.dart';

class SellersNavigationBar extends StatelessWidget {
  const SellersNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColor.primaryColor, // Make sure to update AppColor if needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Transform.scale(
            scale: 0.75,
            child: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != SellersHome()) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.sellerDashboard);
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
                    SellerPetManagement()) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.sellerPetManagement);
                }
              },
              icon: Image.asset("assets/paw.jpg"),
            ),
          ),
          Transform.scale(
            scale: 1,
            child: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name !=
                    SellersAppointment()) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.sellerAppointment);
                }
              },
              icon: Image.asset("assets/calender.png"),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name !=
                    SellersChatList()) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.sellerChatList);
                }
              },
              icon: Image.asset("assets/chat.png"),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != SellersProfile()) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.sellerProfile);
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
