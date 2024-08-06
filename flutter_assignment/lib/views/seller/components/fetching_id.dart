// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class FetchingId extends StatelessWidget {
//   const FetchingId({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<UserProvider>(
//         builder: (context, provider, child) {
//           return FutureBuilder<Map<String, dynamic>>(
//             future: provider.fetchUserDetails(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (snapshot.hasData) {
//                 final userDetails = snapshot.data!;
//                 return UserIdDisplay(userId: userDetails['uid']);
//               } else {
//                 return const Center(child: Text('No data available'));
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class UserIdDisplay extends StatelessWidget {
//   final String userId;

//   const UserIdDisplay({required this.userId, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         "Hello, $userId",
//         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }

// // Example UserProvider class
// class UserProvider with ChangeNotifier {
//   Map<String, dynamic>? _userDetails;

//   Map<String, dynamic>? get userDetails => _userDetails;

//   Future<Map<String, dynamic>> fetchUserDetails() async {
//     // Simulating a network request
//     await Future.delayed(const Duration(seconds: 2));
//     _userDetails = {'uid': '123456'};
//     notifyListeners();
//     return _userDetails!;
//   }
// }
