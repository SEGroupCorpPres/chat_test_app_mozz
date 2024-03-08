import 'dart:developer';
import 'dart:io';

import 'package:chat_app_mozz_test/models/message.dart';
import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/repositories/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessageRepository {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthRepository _authRepository = AuthRepository();

  static User get user => _firebaseAuth.currentUser!;
  static late UserModel currentUser;

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModel userModel) {
    return _firestore.collection('rooms/${getConversationId(userModel.id!)}/messages').snapshots();
  }

  static Future<void> sendMessage(
    UserModel userModel,
    String msg,
    Type type,
  ) async {
    final time = Timestamp.now();
    final Messages message = Messages(
      senderId: user.uid,
      recipientId: userModel.id!,
      isRead: false,
      content: msg,
      timestamp: time,
      type: type,
      comments: [],
    );
    try {
      final CollectionReference reference = _firestore.collection('rooms/${getConversationId(userModel.id!)}/messages');
      await reference.doc(time.millisecondsSinceEpoch.toString()).set(message.toJson());
    } on FirebaseException catch (e) {
      print(e.message.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> sendChatImage(UserModel userModel, File file) async {
    final String ext = file.path.split('.').last;
    log('Extension $ext');
    final Reference reference = _firebaseStorage.ref().child('images/${getConversationId(userModel.id!)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    try {
      await reference.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
            (p0) => log('Data Transferred: ${p0.bytesTransferred / 1000} kb'),
          );
      final String imageUrl = await reference.getDownloadURL();
      await sendMessage(userModel, imageUrl, Type.image);
    } on FirebaseException catch (e) {
      print(e.message.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
