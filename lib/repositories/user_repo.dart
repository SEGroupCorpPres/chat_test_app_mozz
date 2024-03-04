import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/repositories/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersRepository {
  static final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore get firestore => _firebaseFirestore;
  static late UserModel currentUser;

  static Future<void> getCurrentUser() async {
    await _firebaseFirestore.collection('users').doc(_firebaseAuth.currentUser!.uid).get().then(
      (user) async {
        if (user.exists) {
          currentUser = UserModel.fromJson(user.data()!);
        } else {
          await AuthRepository.createUser().then(
            (value) => getCurrentUser(),
          );
        }
      },
    );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return _firebaseFirestore.collection('users').where('id', isNotEqualTo: _firebaseAuth.currentUser!.uid).snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getSingleUserWithId(String id) {
    return _firebaseFirestore.collection('users').doc(id).snapshots();
  }
}
