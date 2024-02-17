
import 'comment.dart';

/// id : "msg1"
/// sender_id : "user1"
/// content : "Hello, everyone!"
/// timestamp : "2024-02-09T11:30:00"
/// type : "text"
/// comments : [{"id":"comment1","sender_id":"user2","content":"Nice to meet you!","timestamp":"2024-02-09T11:35:00"},null]

class Messages {
  Messages({
    this.id,
    this.senderId,
    this.content,
    this.timestamp,
    this.type,
    this.comments,
  });

  Messages.fromJson(dynamic json) {
    id = json['id'];
    senderId = json['sender_id'];
    content = json['content'];
    timestamp = json['timestamp'];
    type = json['type'];
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments?.add(Comments.fromJson(v));
      });
    }
  }

  String? id;
  String? senderId;
  String? content;
  String? timestamp;
  String? type;
  List<Comments>? comments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sender_id'] = senderId;
    map['content'] = content;
    map['timestamp'] = timestamp;
    map['type'] = type;
    if (comments != null) {
      map['comments'] = comments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
