import 'package:chat_app_mozz_test/models/room.dart';
import 'package:chat_app_mozz_test/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ChatRoomsRepository {
  // Firebase authentication instance
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Get current user
  static User get user => _firebaseAuth.currentUser!;

  // Firestore instance
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add chat room to user's chat rooms list
  static Future<void> addChatRoomToUserChatRoomsList(UserModel userModel, String roomId) async {
    final CollectionReference userReference = _firestore.collection('users');

    try {
      // Check if room ID exists in current user's chat rooms list and add it if not
      // Also add room ID to the other user's chat rooms list
      // Each user has a list of chat rooms they are part of
      // This is used to keep track of all chat rooms associated with a user
      if (await isRoomIdExistsInUser(user.uid, roomId)) {
        await userReference.doc(user.uid).update(
          {
            'chat_rooms': FieldValue.arrayUnion([roomId])
          },
        ).then(
          (value) {
            if (kDebugMode) {
              print('Chat room added to current user successfully');
            }
          },
        ).catchError(
          (error) {
            if (kDebugMode) {
              print('Failed to add chat room to current user: $error');
            }
          },
        );
      }
      if (await isRoomIdExistsInUser(userModel.id!, roomId)) {
        await userReference.doc(userModel.id).update(
          {
            'chat_rooms': FieldValue.arrayUnion([roomId])
          },
        ).then(
          (value) {
            if (kDebugMode) {
              print('Chat room added to user successfully');
            }
          },
        ).catchError(
          (error) {
            if (kDebugMode) {
              print('Failed to add chat room to user: $error');
            }
          },
        );
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      return;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return;
    }
  }

  // Check if room ID exists in user's chat rooms list
  static Future<bool> isRoomIdExistsInUser(String userId, String roomId) async {
    // Check if the room ID exists in the user's list of chat rooms
    // This is used to prevent adding duplicate chat rooms to a user's list
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

  // Check if room ID exists in Firestore
  static Future<bool> roomIdExists(String roomId) async {
    // Check if the room ID exists in the Firestore collection of chat rooms
    return (await _firestore.collection('chat_rooms').doc(roomId).get()).exists;
  }

  // Add a chat room if it doesn't already exist
  static Future<void> addChatRoomIsNotExist(String collectionName, String documentId, ChatRooms chatRoom) async {
    // Add a chat room to the Firestore collection of chat rooms if it doesn't already exist
    final CollectionReference chatRoomsReference = _firestore.collection(collectionName);

    // Check if the document already exists
    try {
      if (await roomIdExists(chatRoom.id!)) {
        return;
      } else {
        // Add a new document with the provided ID
        await chatRoomsReference.doc(chatRoom.id).set(chatRoom.toJson()).then(
          (value) {
            if (kDebugMode) {
              print('room added to chat rooms successfully');
            }
          },
        ).catchError(
          (error) {
            if (kDebugMode) {
              print('Failed to add room to chat rooms: $error');
            }
          },
        );
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      return;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return;
    }
  }

  // Add a message ID to the chat room's list of message IDs
  static Future<void> addMessageIdToChatRoomMessageIdList(UserModel userModel, String messageId, String roomId) async {
    // Add the message ID to the chat room's list of message IDs
    // This is used to keep track of all messages associated with a chat room
    final CollectionReference userReference = _firestore.collection('chat_rooms');
    try {
      await userReference.doc(roomId).update(
        {
          'message_id_list': FieldValue.arrayUnion([messageId]),
        },
      ).then(
        (value) {
          if (kDebugMode) {
            print('message_id added to chat rooms successfully');
          }
        },
      ).catchError(
        (error) {
          if (kDebugMode) {
            print('Failed to add message id to chat rooms: $error');
          }
        },
      );
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      return;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return;
    }
  }

  // Get a chat room by its ID
  static Stream<DocumentSnapshot<Map<String, dynamic>>?>? getChatRoom(String roomId) {
    // Get a chat room from Firestore based on its ID
    // This is used to retrieve chat room data for displaying chat details
    try {
      return _firestore.collection('chat_rooms').snapshots().map(
        (QuerySnapshot<Map<String, dynamic>>? rooms) {
          if (rooms != null) {
            for (var room in rooms.docs) {
              if (room.exists && roomId == room.id) {
                return room;
              }
            }
          }
          return null;
        },
      );
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
}
