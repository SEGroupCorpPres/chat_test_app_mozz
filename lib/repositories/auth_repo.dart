// import 'package:chat_test_app_mozz/models/user.dart' as user;
import 'dart:developer';

import 'package:chat_app_mozz_test/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/chat_list_screen.dart';

class AuthRepository {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static User get user => _firebaseAuth.currentUser!;

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
      if (await userExists()) {
        Future.delayed(
          Duration.zero,
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const ChatListScreen()),
          ),
        );
      } else {
        await createUser().then(
          (value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const ChatListScreen()),
            );
          },
        );
      }
      return userCredential.user;

      // initializeFirebase();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<bool> userExists() async {
    return (await _firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<void> createUser() async {
    final registrationDate = Timestamp.now();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final createdUser = UserModel(
      id: user.uid,
      username: user.displayName,
      phoneNumber: user.phoneNumber,
      image: user.photoURL,
      registrationDate: registrationDate,
      status: true,
      pushToken: '',
      lastActivity: registrationDate,
      lastMessageTime: registrationDate,
      chatRooms: [],
    );
    try {
      await _firestore.collection('users').doc(user.uid).set(createdUser.toJson()).onError(
            (e, _) => print("Error writing document: $e"),
          );
      await prefs.setString('uid', user.uid);
      print('User created to successfully!');
    } on FirebaseException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  void saveUserToFirestore(UserModel user) async {
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
