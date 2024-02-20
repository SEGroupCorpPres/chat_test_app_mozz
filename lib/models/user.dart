import 'package:chat_app_mozz_test/models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// id : "user1"
/// username : "john_doe"
/// phone_number : "+998901234567"
/// registration_date : "2024-02-09"
/// last_activity : "2024-02-09T12:30:00"
/// status : "online"
/// last_sms_time : "2024-02-09T12:00:00"
/// chat_rooms : [{"id":"room1","name":"General Chat","created_at":"2024-02-09T10:00:00","last_message_time":"2024-02-09T11:45:00","users":["user1","user2"],"messages":[{"id":"msg1","sender_id":"user1","content":"Hello, everyone!","timestamp":"2024-02-09T11:30:00","type":"text","comments":[{"id":"comment1","sender_id":"user2","content":"Nice to meet you!","timestamp":"2024-02-09T11:35:00"}]},{"id":"msg2","sender_id":"user2","content":"Hi John!","timestamp":"2024-02-09T11:45:00","type":"audio","audio_duration":60,"comments":[{"id":"comment2","sender_id":"user1","content":"This is a nice audio!","timestamp":"2024-02-09T11:50:00"}]},{"id":"msg3","sender_id":"user3","content":"Hey there!","timestamp":"2024-02-09T12:00:00","type":"file","file_info":{"id":"file1","filename":"document.pdf","size":1024},"comments":[{"id":"comment3","sender_id":"user1","content":"Thanks for sharing!","timestamp":"2024-02-09T12:05:00"}]}]}]

class User {
  User({
    this.id,
    this.username,
    this.phoneNumber,
    this.image,
    this.registrationDate,
    this.lastActivity,
    this.status,
    this.lastSmsTime,
    this.chatRooms,
  });

  User.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    phoneNumber = json['phone_number'];
    image = json['image'];
    registrationDate = json['registration_date'];
    lastActivity = json['last_activity'];
    status = json['status'];
    lastSmsTime = json['last_sms_time'];
    if (json['chat_rooms'] != null) {
      chatRooms = [];
      json['chat_rooms'].forEach((v) {
        chatRooms?.add(ChatRooms.fromJson(v));
      });
    }
  }

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      phoneNumber: json['phone_number'],
      image: json['image'],
      registrationDate: json['registration_date'],
      lastActivity: json['last_activity'],
      status: json['status'],
      lastSmsTime: json['last_sms_time'],
      chatRooms: json['chat_rooms'],
    );
  }

  String? id;
  String? username;
  String? phoneNumber;
  String? image;
  Timestamp? registrationDate;
  Timestamp? lastActivity;
  String? status;
  Timestamp? lastSmsTime;
  List<ChatRooms>? chatRooms;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['phone_number'] = phoneNumber;
    map['image'] = image;

    map['registration_date'] = registrationDate;
    map['last_activity'] = lastActivity;
    map['status'] = status;
    map['last_sms_time'] = lastSmsTime;
    if (chatRooms != null) {
      map['chat_rooms'] = chatRooms?.map((v) => v.toJson()).toList();
    }
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
      'last_sms_time': lastSmsTime,
      'chat_rooms': chatRooms,
    };
  }
}
