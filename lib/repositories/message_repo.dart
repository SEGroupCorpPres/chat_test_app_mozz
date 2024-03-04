import 'package:chat_app_mozz_test/models/message.dart';
import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/repositories/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageRepository {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthRepository _authRepository = AuthRepository();

  static User get user => _firebaseAuth.currentUser!;

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModel userModel) {
    return _firestore.collection('rooms/${getConversationId(userModel.id!)}/messages').snapshots();
  }

  static Future<void> sendMessage(UserModel userModel, String msg) async {
    final time = Timestamp.now();
    final Messages message = Messages(
      senderId: user.uid,
      recipientId: userModel.id!,
      isRead: false,
      content: msg,
      timestamp: time,
      type: Type.text,
      comments: [],
    );
    try {

    final CollectionReference reference = _firestore.collection('rooms/${getConversationId(userModel.id!)}/messages');
    await reference.doc(time.millisecondsSinceEpoch.toString()).set(message.toJson());
    } on FirebaseException catch (e){
      print(e.toString());
    } catch (e){
      print(e.toString());
    }
  }
}
