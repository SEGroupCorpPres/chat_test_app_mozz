import 'package:chat_app_mozz_test/models/room.dart';
import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/repositories/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatRoomsRepository {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthRepository _authRepository = AuthRepository();

  static User get user => _firebaseAuth.currentUser!;
  static late UserModel currentUser;
  static late ChatRooms rooms;

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addChatRoomToUserChatRoomsList(UserModel userModel, String roomId) async {
    final CollectionReference userReference = _firestore.collection('users');

    try {
      if (await isRoomIdExistsInUser(user.uid, roomId)) {
        await userReference
            .doc(user.uid)
            .update(
              {
                'chat_rooms': FieldValue.arrayUnion([roomId])
              },
            )
            .then((value) => print('Chat room added to current user successfully'))
            .catchError((error) => print('Failed to add chat room to current user: $error'));
      }
      if (await isRoomIdExistsInUser(userModel.id!, roomId)) {
        await userReference
            .doc(userModel.id)
            .update(
              {
                'chat_rooms': FieldValue.arrayUnion([roomId])
              },
            )
            .then((value) => print('Chat room added to user successfully'))
            .catchError((error) => print('Failed to add chat room to user: $error'));
      }
    } on FirebaseException catch (e) {
      print(e.message.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<bool> isRoomIdExistsInUser(String userId, String roomId) async {
    final DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data();
      final UserModel user = UserModel.fromJson(userData);
      if (userData != null && (user.chatRooms != null || user.chatRooms!.isNotEmpty)) {
        final List<dynamic> chatRooms = user.chatRooms!.toList();
        return chatRooms.contains(roomId);
      }
    }
    return false;
  }

  static Future<bool> roomIdExists(String roomId) async {
    return (await _firestore.collection('chat_rooms').doc(roomId).get()).exists;
  }

  static Future<void> addChatRoomIsNotExist(String collectionName, String documentId, ChatRooms chatRoom) async {
    final CollectionReference chatRoomsReference = _firestore.collection(collectionName);

    // Check if the document already exists
    try {
      if (await roomIdExists(chatRoom.id!)) {
        print('Document already exists');
        return;
      } else {
        // Add a new document with the provided ID
        await chatRoomsReference
            .doc(chatRoom.id)
            .set(chatRoom.toJson())
            .then((value) => print('room added to chat rooms successfully'))
            .catchError((error) => print('Failed to add room to chat rooms: $error'));

        print('Document added successfully');
      }
    } on FirebaseException catch (e) {
      print(e.message.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> addMessageIdToChatRoomMessageIdList(UserModel userModel, String messageId, String roomId) async {
    final CollectionReference userReference = _firestore.collection('chat_rooms');
    try {
      await userReference
          .doc(roomId)
          .update(
            {
              'message_id_list': FieldValue.arrayUnion([messageId]),
            },
          )
          .then((value) => print('message_id added to chat rooms successfully'))
          .catchError((error) => print('Failed to add message id to chat rooms: $error'));
    } on FirebaseException catch (e) {
      print(e.message.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>?>? getChatRoom(String roomId) {
    try {
      return _firestore.collection('chat_rooms').doc(roomId).snapshots().map((doc) {
        if (doc.exists) {
          return doc;
        } else {
          return null;
        }
      });
    } on FirebaseException catch (e) {
      print(e.message.toString());
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
