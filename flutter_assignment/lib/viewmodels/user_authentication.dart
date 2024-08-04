import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class UserAuthentication extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();

  User? _user;
  UserModel? _userModel;
  File? _selectedImage;
  bool _isLoading = false;
  String? _emailError;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
  String? get emailError => _emailError;

  Map<String, dynamic>? get userDetails => _userModel?.toMap();

  void toggleLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setEmailError(String? error) {
    _emailError = error;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          _user = user;
          _userModel = UserModel.fromMap(userDoc.data()!);
          await _firestore
              .collection('users')
              .doc(user.uid)
              .update({'isOnline': true});
          notifyListeners();
        } else {
          // If the user doesn't exist in Firestore, sign them out
          await _firebaseAuth.signOut();
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'User not registered in the system.',
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setEmailError(e.message);
    } catch (e) {
      setEmailError('An error occurred. Please try again.');
    }
  }

  Future<void> signOut() async {
    if (_user != null) {
      await _firestore.collection('users').doc(_user!.uid).update({
        'isOnline': false,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
    await _firebaseAuth.signOut();
    _user = null;
    _userModel = null;
    notifyListeners();
  }

  Future<void> updateOnlineStatus(bool isOnline, FieldValue? lastSeen) async {
    if (_user != null) {
      final updateData = {
        'isOnline': isOnline,
      };
      if (lastSeen != null) {
        updateData['lastSeen'] = lastSeen as bool;
      }
      await _firestore.collection('users').doc(_user!.uid).update(updateData);
      notifyListeners();
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String email,
      String password,
      String fullName,
      String role,
      String location,
      String phoneNumber,
      VoidCallback onSuccess) async {
    toggleLoading(true);
    setEmailError(null);

    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        String? imageUrl;
        if (_selectedImage != null) {
          imageUrl = await _uploadImage(_selectedImage!);
        }

        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          fullName: fullName,
          role: role,
          location: location,
          phoneNumber: phoneNumber,
          profileImage: imageUrl,
          isOnline: false,
          lastSeen: null,
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

        _user = user;
        _userModel = newUser;
        notifyListeners();

        onSuccess();
      }
      toggleLoading(false);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          setEmailError('This email is already registered.');
          break;
        case 'invalid-email':
          setEmailError('The email address is not valid.');
          break;
        default:
          print('Error occurred: $e');
          break;
      }
      toggleLoading(false);
    } catch (e) {
      print('Error occurred: $e');
      toggleLoading(false);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedImage =
        await _imagePicker.pickImage(source: source, imageQuality: 70);
    if (pickedImage != null) {
      _selectedImage = File(pickedImage.path);
      notifyListeners();
    }
  }

  void resetSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageReference.putFile(image);
      final completedTask = await uploadTask;
      return await completedTask.ref.getDownloadURL();
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
  }

  void setupAuthStateListener() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        _user = user;
        _fetchUserDetails(user.uid);
      } else {
        _user = null;
        _userModel = null;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUserDetails(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('users').doc(uid).get();

    if (userDoc.exists) {
      _userModel = UserModel.fromMap(userDoc.data()!);
      notifyListeners();
    }
  }
}
