import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assignment/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  DocumentSnapshot<Map<String, dynamic>>? _userDetails;

  User? get user => _user;
  DocumentSnapshot<Map<String, dynamic>>? get userDetails => _userDetails;

  UserProvider() {
    _setupAuthStateListener();
  }

  Future<void> fetchUserDetails() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _userDetails = await _authService.getUserDetails(_user!.uid);
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    if (_user != null) {
      await _authService.signOut();
      _user = null;
      _userDetails = null;
      notifyListeners();
    }
  }

  void _setupAuthStateListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _user = user;
        fetchUserDetails();
      } else {
        if (_user != null) {
          _user = null;
          _userDetails = null;
          notifyListeners();
        }
      }
    });
  }
}
