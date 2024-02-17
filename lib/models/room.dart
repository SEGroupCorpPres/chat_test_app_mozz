

import 'package:chat_app_mozz_test/models/message.dart';

/// id : "room1"
/// name : "General Chat"
/// created_at : "2024-02-09T10:00:00"
/// last_message_time : "2024-02-09T11:45:00"
/// users : ["user1","user2"]
/// messages : [{"id":"msg1","sender_id":"user1","content":"Hello, everyone!","timestamp":"2024-02-09T11:30:00","type":"text","comments":[{"id":"comment1","sender_id":"user2","content":"Nice to meet you!","timestamp":"2024-02-09T11:35:00"}]},{"id":"msg2","sender_id":"user2","content":"Hi John!","timestamp":"2024-02-09T11:45:00","type":"audio","audio_duration":60,"comments":[{"id":"comment2","sender_id":"user1","content":"This is a nice audio!","timestamp":"2024-02-09T11:50:00"}]},{"id":"msg3","sender_id":"user3","content":"Hey there!","timestamp":"2024-02-09T12:00:00","type":"file","file_info":{"id":"file1","filename":"document.pdf","size":1024},"comments":[{"id":"comment3","sender_id":"user1","content":"Thanks for sharing!","timestamp":"2024-02-09T12:05:00"}]}]

class ChatRooms {
  ChatRooms({
    this.id,
    this.name,
    this.createdAt,
    this.lastMessageTime,
    this.users,
    this.messages,});

  ChatRooms.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    lastMessageTime = json['last_message_time'];
    users = json['users'] != null ? json['users'].cast<String>() : [];
    if (json['messages'] != null) {
      messages = [];
      json['messages'].forEach((v) {
        messages?.add(Messages.fromJson(v));
      });
    }
  }
  String? id;
  String? name;
  String? createdAt;
  String? lastMessageTime;
  List<String>? users;
  List<Messages>? messages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['created_at'] = createdAt;
    map['last_message_time'] = lastMessageTime;
    map['users'] = users;
    if (messages != null) {
      map['messages'] = messages?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}