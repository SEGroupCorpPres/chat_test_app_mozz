import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app_mozz_test/models/message.dart';
import 'package:chat_app_mozz_test/models/room.dart';
import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/repositories/auth_repo.dart';
import 'package:chat_app_mozz_test/repositories/room_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessageRepository {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthRepository _authRepository = AuthRepository();

  ChatRoomsRepository _roomsRepository = ChatRoomsRepository();

  static User get user => _firebaseAuth.currentUser!;
  static late UserModel currentUser;
  static late ChatRooms rooms;
  static late Messages messages;
  static late String lastMessageID;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModel userModel) {
    return _firestore.collection('messages').snapshots();
  }

  static Stream<String?>? getLastMessageId(String roomID) {
    StreamController<String?> controller = StreamController<String?>();
    final room = ChatRoomsRepository.getChatRoom(roomID);
    try {
      room!.listen((snapshot) {
        if (snapshot != null && snapshot.exists) {
          var data = snapshot.data();
          ChatRooms chatRooms = ChatRooms.fromJson(data);
          if (chatRooms.messageIDList!.isNotEmpty) {
            final List<String> messageIDList = chatRooms.messageIDList!.toList();
            String lastMessageId = messageIDList.last;
            controller.add(lastMessageId);
          } else {
            controller.add(null);
          }
        }
      });
    } on FirebaseException catch (e) {
      print(e.message.toString());
      controller.add(null);
    } catch (e) {
      print(e.toString());
      controller.add(null);
    }
    return controller.stream;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>?>? getMessage(String messageId) {
    try {
      print(messageId + 'message');
      return _firestore.collection('messages').doc(messageId).snapshots().map((message) {
        if (message.exists) {
          print(message);
          return message;
        } else {
          return null;
        }
      });
    } on FirebaseException catch (e) {
      print(e.message.toString());
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<void> sendMessage(
    UserModel userModel,
    String msg,
    Type type,
  ) async {
    final time = Timestamp.now();
    final Messages message = Messages(
      id: time.millisecondsSinceEpoch.toString(),
      senderId: user.uid,
      recipientId: userModel.id!,
      isRead: false,
      content: msg,
      timestamp: time,
      type: type,
      comments: [],
    );
    final ChatRooms chatRoom = ChatRooms(
      id: getConversationId(userModel.id!),
      messageIDList: [],
    );
    try {
      await ChatRoomsRepository.addChatRoomIsNotExist(
        'chat_rooms',
        getConversationId(userModel.id!),
        chatRoom,
      ).then((value) => print('Chat room id added to chat rooms successfully')).catchError(
            (error) => print('Failed to add chat room id to chat rooms: $error'),
          );
      await ChatRoomsRepository.addChatRoomToUserChatRoomsList(
        userModel,
        getConversationId(userModel.id!),
      ).then(
        (value) async => await ChatRoomsRepository.addMessageIdToChatRoomMessageIdList(
          userModel,
          message.id,
          getConversationId(userModel.id!),
        ),
      );
      final CollectionReference messagesRef = _firestore.collection('messages');
      await messagesRef.doc(message.id).set(message.toJson());
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
