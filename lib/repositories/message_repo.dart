import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app_mozz_test/models/message.dart';
import 'package:chat_app_mozz_test/models/room.dart';
import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/repositories/room_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessageRepository {
  // Firebase authentication , cloud firestore and storage instances
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  static User get user => _firebaseAuth.currentUser!;

  // Get conversation ID based on user IDs
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';

  // Stream of all messages given a list of message IDs
  static Stream<List<DocumentSnapshot<Map<String, dynamic>>>>? getAllMessages(List<String> messageIdList) {
    try {
      return _firestore.collection('messages').snapshots().map(
        (QuerySnapshot<Map<String, dynamic>>? snapshot) {
          List<DocumentSnapshot<Map<String, dynamic>>> messageList = [];
          if (snapshot != null) {
            for (var message in snapshot.docs) {
              if (message.exists && messageIdList.contains(message.id)) {
                messageList.add(message);
              }
            }
          } else {
            return [];
          }
          return messageList;
        },
      );
    } on FirebaseException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  // Stream of the last message ID in a chat room
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
      controller.add(null);
    } catch (e) {
      controller.add(null);
    }
    return controller.stream;
  }

  // Stream of a single message given its ID
  static Stream<DocumentSnapshot<Map<String, dynamic>>?>? getMessage(String messageId) {
    try {
      return _firestore.collection('messages').doc(messageId).snapshots().map(
        (message) {
          if (message.exists) {
            return message;
          } else {
            return null;
          }
        },
      );
    } on FirebaseException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  // Send a message
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
      // Add chat room ID to chat rooms if it doesn't exist
      await ChatRoomsRepository.addChatRoomIsNotExist(
        'chat_rooms',
        getConversationId(userModel.id!),
        chatRoom,
      ).then((value) => log('Chat room id added to chat rooms successfully')).catchError(
            (error) => log('Failed to add chat room id to chat rooms: $error'),
          );
      // Add chat room to user's chat rooms list
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
      // Add message to Firestore
      final CollectionReference messagesRef = _firestore.collection('messages');
      await messagesRef.doc(message.id).set(message.toJson());
    } on FirebaseException catch (e) {
      return;
    } catch (e) {
      return;
    }
  }

  // Send an image in a chat
  static Future<void> sendChatImage(UserModel userModel, File file) async {
    final String ext = file.path.split('.').last;
    final Reference reference = _firebaseStorage.ref().child('images/${getConversationId(userModel.id!)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    try {
      // Upload image to Firebase Storage
      await reference.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
            (p0) => log('Data Transferred: ${p0.bytesTransferred / 1000} kb'),
          );
      // Get image URL and send it as a message
      final String imageUrl = await reference.getDownloadURL();
      await sendMessage(userModel, imageUrl, Type.image);
    } on FirebaseException catch (e) {
      return;
    } catch (e) {
      return;
    }
  }
}
