// import 'package:chat_test_app_mozz/models/user.dart' as user;
import 'dart:developer';

import 'package:chat_app_mozz_test/models/user.dart' as users;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/chat_list_screen.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential).then(
        (value) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('uid', value.user!.uid);
          return value;
        },
      );
      log('\nUser: ${userCredential.user}');
      log('\nUser: ${userCredential.additionalUserInfo}');

      if (userCredential.user != null) {
        users.User user = users.User(
          id: userCredential.user!.uid,
          username: userCredential.user!.displayName,
          phoneNumber: userCredential.user!.phoneNumber,
          image: userCredential.user!.photoURL,
          registrationDate: Timestamp.now(),
          status: 'online',
          chatRooms: [],
        );
        saveUserToFirestore(user);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ChatListScreen(),
          ),
        );
      }
      return userCredential.user;

      // initializeFirebase();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //
  // void initializeFirebase() async {
  //   await Firebase.initializeApp();
  // }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  void saveUserToFirestore(users.User user) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.id).set(user.toMap()).onError(
            (e, _) => print("Error writing document: $e"),
          );
      await prefs.setString('uid', user.id!);
      print('User saved to Firestore successfully!');
    } catch (e) {
      print('Error saving user to Firestore: $e');
    }
  }
}
