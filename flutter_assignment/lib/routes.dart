import 'package:flutter/material.dart';
import 'screens/admin/admin_dashboard.dart';

import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/common/splash_screen.dart';

//Adopters
// import 'screens/adopter/adopter_dashboard.dart';
// import "screens/adopter/adding_testing_data.dart";
// import "screens/adopter/adopters_appointment.dart";
// import "screens/adopter/adopters_favourite.dart";
// import "screens/adopter/adopters_filter.dart";
import "screens/adopter/adopters_home.dart";
// import "screens/adopter/adopters_notification.dart";
// import "screens/adopter/adopters_post_details.dart";
import "screens/adopter/adopters_profile.dart";
import "screens/adopter/getting_testing_data.dart";

//Seller
import 'screens/seller/seller_dashboard.dart';

//Admin
import 'screens/admin/admin_user_management.dart';
import 'screens/admin/admin_create_user.dart';
import 'screens/admin/admin_pet_management.dart';
import 'screens/admin/admin_select_seller_screen.dart';
import 'screens/admin/admin_add_pet.dart';
import 'screens/admin/admin_appo_management.dart';
import 'screens/admin/admin_edit_user.dart';


class AppRoutes {
  static const String splashScreen = '/';
  
  
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String sellerDashboard = '/sellerDashboard';


  //Adaptor
  //static const String adopterDashboard = '/adopterDashboard';
  static const String adopterDashboard = '/AdoptersHome';



  //Seller
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
      case adopterDashboard:
        return MaterialPageRoute(builder: (_) =>  AdoptersHome());
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
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
