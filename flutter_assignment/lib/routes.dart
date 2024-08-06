import 'package:flutter/material.dart';
import 'views/splash_screen.dart';
import 'views/sign_up_screen.dart';
import 'views/sign_in_screen.dart';
import 'views/admin/admin_dashboard.dart';
import 'views/admin/admin_user_management.dart';
import 'views/admin/admin_pet_management.dart';
import 'views/admin/admin_booking_management.dart';
import 'views/admin/admin_add_pet.dart';
import 'views/admin/admin_add_booking.dart';
import 'views/admin/admin_pick_seller_booking.dart';
import 'views/admin/admin_pickpet_booking.dart';
import 'views/admin/admin_pick_adopter_booking.dart';
import 'views/admin/admin_feedback.dart';

// Adopters
import 'package:flutter_assignment/views/adopter/adopters_chat.dart';
import 'package:flutter_assignment/views/adopter/adopters_filter.dart';
import 'package:flutter_assignment/views/adopter/adopters_help.dart';
import 'package:flutter_assignment/views/adopter/adopters_notification.dart';
//import 'package:flutter_assignment/views/adopter/adopters_post_details.dart';
import 'package:flutter_assignment/views/adopter/adopters_reminder.dart';
//import 'package:flutter_assignment/views/adopter/adopters_booking_details.dart';
import 'package:flutter_assignment/views/adopter/adopters_home.dart';
import 'package:flutter_assignment/views/adopter/adopters_favourite.dart';
import 'package:flutter_assignment/views/adopter/adopters_appointment.dart';
import 'package:flutter_assignment/views/adopter/adopters_chat_list.dart';
import 'package:flutter_assignment/views/adopter/adopters_profile.dart';
import 'package:flutter_assignment/views/adopter/adopters_edit_profile.dart';

// Seller
import 'views/seller/sellers_appointment.dart';
import 'views/seller/sellers_chat_list.dart';
import 'views/seller/sellers_profile.dart';
import 'views/seller/seller_add_pet.dart';
import 'views/seller/seller_pet_management.dart';
import 'views/seller/sellers_booking_details.dart';
import 'views/seller/sellers_booking_history.dart';
import 'views/seller/sellers_edit_profile.dart';
import 'views/seller/sellers_help.dart';
import 'views/seller/sellers_home.dart';
import 'views/seller/sellers_notification.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String signUp = '/signUp';
  static const String signIn = '/signIn';
  static const String adminDashboard = '/adminDashboard';
  static const String adminUserManagement = '/adminUserManagement';
  static const String adminPetManagement = '/adminPetManagement';
  static const String adminSelectSellerPet = '/adminSelectSellerPet';
  static const String adminAddPet = '/adminAddPet';
  static const String adminAppoManagement = '/adminAppoManagement';
  static const String adminAddAppointment =
      '/adminAddAppointment'; // New route for Add Appointment
  static const String adminSelectSellerAppointment = '/adminSelectSellerAppo';
  static const String adminSelectPetForAppoScreen =
      '/adminSelectPetForAppoScreen';
  static const String adminSelectAdopterAppointment = '/adminSelectAdopterAppo';
  static const String adminFeedbacks = '/adminFeedback';

  // Adopter
  static const String adopterDashboard = '/adopterDashboard';
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
  static const String adopterChat = '/AdoptersChat';
  static const String adopterEditProfile = '/AdoptersEditProfile';

  // Seller
  static const String sellerDashboard = '/sellerDashboard';
  static const String sellerAppointment = '/sellersAppointment';
  static const String sellerChatList = '/sellersChatList';
  static const String sellerProfile = '/sellersProfile';
  static const String sellerBookingDetails = '/sellersBookingDetails';
  static const String sellerNotification = '/sellernotification';
  static const String sellerBookingHistory = '/BookingHistory';
  static const String sellerHelp = '/sellerhelp';
  static const String sellerChat = '/sellersChat';
  static const String sellerEditProfile = '/sellersEditProfile';
  static const String sellerAddPet = '/sellerAddPet';
  static const String sellerPetManagement = '/sellerPetManagement';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      case adminUserManagement:
        return MaterialPageRoute(builder: (_) => const AdminUserManagement());
      case adminPetManagement:
        return MaterialPageRoute(builder: (_) => const AdminPetManagement());
      case adminAddPet:
        final sellerUid = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => AdminAddPet(sellerUid: sellerUid));
      case adminAppoManagement:
        return MaterialPageRoute(
            builder: (_) => const AdminBookingManagement());
      case adminAddAppointment:
        final args = settings.arguments as Map<String, String>;
        final sellerUid = args['sellerUid']!;
        final petUid = args['petUid']!;
        final adopterUid = args['adopterUid']!;
        return MaterialPageRoute(
            builder: (_) => AdminAddAppointment(
                  sellerUid: sellerUid,
                  petUid: petUid,
                  adopterUid: adopterUid,
                ));

      case adminSelectSellerAppointment:
        return MaterialPageRoute(
            builder: (_) => const AdminSelectSellerForAppoScreen());

      case adminSelectAdopterAppointment:
        final args = settings.arguments as Map<String, dynamic>;
        final sellerUid = args['sellerUid'] as String;
        final petUid = args['petUid'] as String;
        return MaterialPageRoute(
            builder: (_) => AdminSelectAdopterForAppoScreen(
                sellerUid: sellerUid, petUid: petUid));

      case adminSelectPetForAppoScreen:
        final sellerUid = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => AdminSelectPetForAppoScreen(sellerUid: sellerUid));

      case adminFeedbacks:
        return MaterialPageRoute(
            builder: (_) => const AdminFeedbackManagement());

      // Adopter

      case adopterDashboard:
        return MaterialPageRoute(
            builder: (_) => const AdoptersHome(), settings: settings);
      case adopterFavourite:
        return MaterialPageRoute(builder: (_) => const AdoptersFavourite());
      case adopterAppointment:
        return MaterialPageRoute(builder: (_) => AdoptersAppointment());
      case adopterChatList:
        return MaterialPageRoute(builder: (_) => const AdoptersChatList());
      case adopterProfile:
        return MaterialPageRoute(builder: (_) => AdoptersProfile());
      case adopterEditProfile:
        final args = settings.arguments as Map<String, dynamic>;
        final userId = args['userId'] as String;
        return MaterialPageRoute(
            builder: (_) => AdopterEditProfile(userId: userId));
      // case adopterPostDetails:
      //   final detailsArgs = settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //     builder: (_) => AdoptersPostDetails(
      //       postName: detailsArgs['postName'],
      //       postImage: detailsArgs['postImage'],
      //       postPetName: detailsArgs['postPetName'],
      //       postPurpose: detailsArgs['postPurpose'],
      //       postDescription: detailsArgs['postDescription'],
      //       postSellerUid: detailsArgs['sellerUid'],
      //       postLocation: detailsArgs['postLocation'],
      //       postSpecies: detailsArgs['postSpecies'],
      //       postFees: detailsArgs['postFees'],
      //     ),
      //   );
      // case adopterBookingDetails:
      //   final args = settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //     builder: (_) => AdoptersBookingDetails(
      //       postName: args['postName'],
      //       postImage: args['postImage'],
      //       postPetName: args['postPetName'],
      //       postPurpose: args['postPurpose'],
      //       postDescription: args['postDescription'],
      //       date: args['date'],
      //       time: args['time'],
      //       phoneNumber: args['phoneNumber'],
      //       notes: args['notes'],
      //       bookingId: args['bookingId'],
      //     ),
      //   );
      case adopterNotification:
        return MaterialPageRoute(builder: (_) => AdoptersNotification());
      case adopterFilter:
        return MaterialPageRoute(builder: (_) => const AdoptersFilter());
      case adopterReminder:
        return MaterialPageRoute(builder: (_) => AdoptersReminder());
      case adopterHelp:
        return MaterialPageRoute(builder: (_) => const AdoptersHelp());
      case adopterChat:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AdoptersChat(
            userId: args['userId'],
            userName: args['userName'],
            userImage: args['userImage'],
          ),
        );

      // Seller
      case sellerDashboard:
        return MaterialPageRoute(
            builder: (_) => const SellersHome(), settings: settings);
      case sellerPetManagement:
        return MaterialPageRoute(builder: (_) => const SellerPetManagement());
      case sellerAddPet:
        return MaterialPageRoute(
          builder: (_) => AddPet(
            sellerUid: '',
          ),
        );
      case sellerAppointment:
        return MaterialPageRoute(builder: (_) => SellersAppointment());
      case sellerChatList:
        return MaterialPageRoute(builder: (_) => const SellersChatList());
      case sellerProfile:
        return MaterialPageRoute(builder: (_) => SellersProfile());
      case sellerEditProfile:
        final args = settings.arguments as Map<String, dynamic>;
        final userId = args['userId'] as String;
        return MaterialPageRoute(
            builder: (_) => SellerEditProfile(userId: userId));

      case sellerBookingDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SellersBookingDetails(
            postName: args['postName'],
            postImage: args['postImage'],
            postPetName: args['postPetName'],
            postPurpose: args['postPurpose'],
            postDescription: args['postDescription'],
            date: args['date'],
            time: args['time'],
            phoneNumber: args['phoneNumber'],
            notes: args['notes'],
            bookingId: args['bookingId'],
          ),
        );
      case sellerNotification:
        return MaterialPageRoute(builder: (_) => SellersNotification());
      case sellerBookingHistory:
        return MaterialPageRoute(builder: (_) => const BookingHistory());
      case sellerHelp:
        return MaterialPageRoute(builder: (_) => const SellersHelp());
      case sellerChat:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AdoptersChat(
            userId: args['userId'],
            userName: args['userName'],
            userImage: args['userImage'],
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
