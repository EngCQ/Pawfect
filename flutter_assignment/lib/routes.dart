import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/screens/adopter/adopters_filter.dart';
import 'package:flutter_assignment/screens/adopter/adopters_help.dart';
import 'package:flutter_assignment/screens/adopter/adopters_notification.dart';
import 'package:flutter_assignment/screens/adopter/adopters_post_details.dart';
import 'package:flutter_assignment/screens/adopter/adopters_reminder.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_booking_details.dart';
import 'package:flutter_assignment/screens/auth/sign_in_screen.dart';
import 'package:flutter_assignment/screens/auth/sign_up_screen.dart';
import 'package:flutter_assignment/screens/common/splash_screen.dart';
import 'package:flutter_assignment/screens/admin/admin_dashboard.dart';
import 'package:flutter_assignment/screens/adopter/adopters_home.dart';
import 'package:flutter_assignment/screens/adopter/adopters_favourite.dart';
import 'package:flutter_assignment/screens/adopter/adopters_appointment.dart';
import 'package:flutter_assignment/screens/adopter/adopters_chat_list.dart';
import 'package:flutter_assignment/screens/adopter/adopters_profile.dart';
import 'package:flutter_assignment/screens/seller/seller_dashboard.dart';
import 'package:flutter_assignment/screens/admin/admin_user_management.dart';
import 'package:flutter_assignment/screens/admin/admin_create_user.dart';
import 'package:flutter_assignment/screens/admin/admin_pet_management.dart';
import 'package:flutter_assignment/screens/admin/admin_select_seller_screen.dart';
import 'package:flutter_assignment/screens/admin/admin_add_pet.dart';
import 'package:flutter_assignment/screens/admin/admin_appo_management.dart';
import 'package:flutter_assignment/screens/admin/admin_edit_user.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String sellerDashboard = '/sellerDashboard';

  //Adopter
  static const String adopterDashboard = '/AdoptersHome';
  static const String adopterFavourite = '/AdoptersFavourite';
  static const String adopterAppointment = '/AdoptersAppointment';
  static const String adopterChatList = '/AdoptersChatList';
  static const String adopterProfile = '/AdoptersProfile';
  static const String adopterPostDetails = '/AdoptersPostDetails';
  static const String adopterBookingDetails = '/AdoptersBookingDetails';
  static const String adopterNotification = '/notification';
  static const String adopterFilter = '/filter';
  static const String adopterReminder = '/reminder';
  static const String adopterHelp = '/help';

  //Admin
  static const String adminDashboard = '/adminDashboard';
  static const String adminUserManagement = '/adminUserManagement';
  static const String adminAddUser = '/adminAddUser';
  static const String adminEditUser = '/adminEditUser';
  static const String adminPetManagement = '/adminPetManagement';
  static const String adminSelectSeller = '/adminSelectSeller';
  static const String adminAddPet = '/AdminAddPet';
  static const String adminAppoManagement = '/adminAppoManagement';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      case sellerDashboard:
        return MaterialPageRoute(builder: (_) => const SellerDashboard());
      case adminUserManagement:
        return MaterialPageRoute(builder: (_) => const AdminUserManagement());
      case adminAddUser:
        return MaterialPageRoute(builder: (_) => const AdminAddUser());
      case adminEditUser:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AdminEditUser(userId: args['userId']),
        );
      case adminPetManagement:
        return MaterialPageRoute(builder: (_) => const AdminPetManagement());
      case adminSelectSeller:
        return MaterialPageRoute(builder: (_) => const SelectSellerScreen());
      case adminAddPet:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AdminAddPet(sellerUid: args['sellerUid']),
        );
      case adminAppoManagement:
        return MaterialPageRoute(builder: (_) => const AdminAppoManagement());
      case adopterDashboard:
        return MaterialPageRoute(builder: (_) => const AdoptersHome());
      case adopterFavourite:
        return MaterialPageRoute(builder: (_) => AdoptersFavourite());
      case adopterAppointment:
        return MaterialPageRoute(builder: (_) => AdoptersAppointment());
      case adopterChatList:
        return MaterialPageRoute(builder: (_) => AdoptersChatList());
      case adopterProfile:
        return MaterialPageRoute(builder: (_) => const AdoptersProfile());
      case adopterPostDetails:
        final detailsArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AdoptersPostDetails(
            postName: detailsArgs['postName'],
            postImage: detailsArgs['postImage'],
            postPetName: detailsArgs['postPetName'],
            postType: detailsArgs['postType'],
            postDescription: detailsArgs['postDescription'],
            postSellerUid: detailsArgs['sellerUid'],
          ),
        );

      case adopterBookingDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AdoptersBookingDetails(
            postName: args['postName'],
            postImage: args['postImage'],
            postPetName: args['postPetName'],
            postType: args['postType'],
            postDescription: args['postDescription'],
            date: args['date'],
            time: args['time'],
            phoneNumber: args['phoneNumber'],
            notes: args['notes'],
            bookingId: args['bookingId'],
          ),
        );
      case adopterNotification:
        return MaterialPageRoute(builder: (_) => AdoptersNotification());
      case adopterFilter:
        return MaterialPageRoute(builder: (_) => AdoptersFilter());
      case adopterReminder:
        return MaterialPageRoute(builder: (_) => AdoptersReminder());
      case adopterHelp:
        return MaterialPageRoute(builder: (_) => AdoptersHelp());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
