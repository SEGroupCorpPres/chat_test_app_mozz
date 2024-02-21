import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app_mozz_test/models/user.dart';

Stream<List<User>> getUserListStream() {
  // Get a reference to the Firestore collection
  CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  // Return a stream of the user document snapshots mapped to a list of User objects
  return usersCollection.snapshots().map((QuerySnapshot snapshot) {
    List<User> userList = [];
    for (var document in snapshot.docs) {
      if (document.exists) {
        // User document exists
        Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
        // Create a User object from the user data
        User user = User.fromMap(userData);
        userList.add(user);
      }
    }
    return userList;
  });
}