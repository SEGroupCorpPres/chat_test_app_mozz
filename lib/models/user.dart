import 'package:chat_app_mozz_test/models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// id : "user1"
/// username : "john_doe"
/// phone_number : "+998901234567"
/// registration_date : "2024-02-09"
/// last_activity : "2024-02-09T12:30:00"
/// status : "online"
/// last_sms_time : "2024-02-09T12:00:00"
/// chat_rooms : [{"id":"room1","name":"General Chat","created_at":"2024-02-09T10:00:00","last_message_time":"2024-02-09T11:45:00","userModels":["userModel1","userModel2"],"messages":[{"id":"msg1","sender_id":"userModel1","content":"Hello, everyone!","timestamp":"2024-02-09T11:30:00","type":"text","comments":[{"id":"comment1","sender_id":"userModel2","content":"Nice to meet you!","timestamp":"2024-02-09T11:35:00"}]},{"id":"msg2","sender_id":"userModel2","content":"Hi John!","timestamp":"2024-02-09T11:45:00","type":"audio","audio_duration":60,"comments":[{"id":"comment2","sender_id":"userModel1","content":"This is a nice audio!","timestamp":"2024-02-09T11:50:00"}]},{"id":"msg3","sender_id":"userModel3","content":"Hey there!","timestamp":"2024-02-09T12:00:00","type":"file","file_info":{"id":"file1","filename":"document.pdf","size":1024},"comments":[{"id":"comment3","sender_id":"userModel1","content":"Thanks for sharing!","timestamp":"2024-02-09T12:05:00"}]}]}]

class UserModel {
  UserModel({
    this.id,
    this.username,
    this.phoneNumber,
    this.image,
    this.registrationDate,
    this.lastActivity,
    this.status,
    this.lastMessageTime,
    this.chatRooms,
    this.pushToken,
  });

  UserModel.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    phoneNumber = json['phone_number'];
    image = json['image'];
    registrationDate = json['registration_date'];
    lastActivity = json['last_activity'];
    status = json['status'];
    lastMessageTime = json['last_message_time'];
    pushToken = json['push_token'];
    json['chat_rooms'] != null ? List<String>.from(json['chat_rooms']) : [];
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    var temp;
    return UserModel(
      id: map['id'],
      username: map['username'],
      phoneNumber: map['phone_number'],
      image: map['image'],
      registrationDate: map['registration_date'],
      lastActivity: map['last_activity'],
      status: map['status'],
      lastMessageTime: map['last_message_time'],
      chatRooms: null == (temp = map['chatRooms'])
          ? []
          : (temp is List
              ? temp
                  .map(
                    (map) => ChatRooms.fromJson(map),
                  )
                  .toList()
              : []),
      pushToken: map['push_token'] as String,
    );
  }

  String? id;
  String? username;
  String? phoneNumber;
  String? image;
  Timestamp? registrationDate;
  Timestamp? lastActivity;
  bool? status;
  Timestamp? lastMessageTime;
  List<ChatRooms>? chatRooms;
  String? pushToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['phone_number'] = phoneNumber;
    map['image'] = image;

    map['registration_date'] = registrationDate;
    map['last_activity'] = lastActivity;
    map['status'] = status;
    map['last_message_time'] = lastMessageTime;
    if (chatRooms != null) {
      map['chat_rooms'] = chatRooms?.map((v) => v.toJson()).toList();
    }
    map['push_token'] = pushToken;
    return map;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'phone_number': phoneNumber,
      'image': image,
      'registration_date': registrationDate,
      'last_activity': lastActivity,
      'status': status,
      'last_message_time': lastMessageTime,
      'chat_rooms': chatRooms,
      'push_token': pushToken,
    };
  }
}
