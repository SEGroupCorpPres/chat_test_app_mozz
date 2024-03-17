import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/screens/chat_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current user from FirebaseAuth
  static User get user => _firebaseAuth.currentUser!;

  // Sign in with Google
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential).then(
        (value) async {
          // Save user ID to SharedPreferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('uid', value.user!.uid);
          return value;
        },
      );

      // Check if user exists in Firestore
      if (await userExists()) {
        // Navigate to chat list screen if user exists
        Future.delayed(
          Duration.zero,
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const ChatListScreen()),
          ),
        );
      } else {
        // Create user document in Firestore if user does not exist
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
    } catch (e) {
      // Handle sign-in errors
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  // Check if user document exists in Firestore
  static Future<bool> userExists() async {
    return (await _firestore.collection('users').doc(user.uid).get()).exists;
  }

  // Create user document in Firestore
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
      // Write user document to Firestore
      await _firestore.collection('users').doc(user.uid).set(createdUser.toJson()).onError(
        (e, _) {
          if (kDebugMode) {
            print("Error writing document: $e");
          }
        },
      );
      await prefs.setString('uid', user.uid);
      if (kDebugMode) {
        print('User created successfully!');
      }
    } on FirebaseException catch (e) {
      // Handle Firestore exceptions
      if (kDebugMode) {
        print(e.toString());
      }
      return;
    } catch (e) {
      // Handle other exceptions
      if (kDebugMode) {
        print(e.toString());
      }
      return;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
