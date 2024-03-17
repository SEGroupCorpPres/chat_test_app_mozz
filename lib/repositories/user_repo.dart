import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/repositories/auth_repo.dart'; // Importing AuthRepository for user creation if not exists
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersRepository {
  // Firestore instance
  static final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Firebase authentication instance
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Getters for Firestore instance and current user
  static FirebaseFirestore get firestore => _firebaseFirestore;
  static late UserModel currentUser;

  // Method to get the current user from Firestore
  static Future<void> getCurrentUser() async {
    await _firebaseFirestore.collection('users').doc(_firebaseAuth.currentUser!.uid).get().then(
      (user) async {
        if (user.exists) {
          // If the user exists in Firestore, set currentUser
          currentUser = UserModel.fromJson(user.data()!);
        } else {
          // If the user doesn't exist in Firestore, create a new user and then get the current user again
          await AuthRepository.createUser().then(
            (value) => getCurrentUser(),
          );
        }
      },
    );
  }

  // Method to get all users from Firestore except the current user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return _firebaseFirestore.collection('users').where('id', isNotEqualTo: _firebaseAuth.currentUser!.uid).snapshots();
  }

  // Method to get a single user by their ID from Firestore
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getSingleUserWithId(String id) {
    return _firebaseFirestore.collection('users').doc(id).snapshots();
  }
}
