import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment.dart';

/// id : "msg1"
/// sender_id : "user1"
/// content : "Hello, everyone!"
/// timestamp : "2024-02-09T11:30:00"
/// type : "text"
/// comments : [{"id":"comment1","sender_id":"user2","content":"Nice to meet you!","timestamp":"2024-02-09T11:35:00"},null]

class Messages implements Comparable {
  Messages({
    // required this.id,
    required this.senderId,
    required this.recipientId,
    required this.isRead,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.comments,
  });

  Messages.fromJson(dynamic json) {
    // id = json['id'] as String;
    senderId = json['sender_id'] as String;
    recipientId = json['recipient_id'] as String;
    isRead = json['is_read'] as bool;
    content = json['content'] as String;
    timestamp = json['timestamp'];
    type = json['type'] as String == Type.image.name
        ? Type.image
        : json['type'] as String == Type.video.name
            ? Type.video
            : json['type'] as String == Type.audio.name
                ? Type.audio
                : Type.text;
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach(
        (v) {
          comments?.add(Comments.fromJson(v));
        },
      );
    }
  }

  // late final String? id;
  late final String senderId;
  late final String recipientId;
  late final bool isRead;
  late final String content;
  late final Timestamp timestamp;
  late final Type type;
  late final List<Comments>? comments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    // map['id'] = id;
    map['sender_id'] = senderId;
    map['recipient_id'] = recipientId;
    map['is_read'] = isRead;
    map['content'] = content;
    map['timestamp'] = timestamp;
    map['type'] = type.name;
    if (comments != null) {
      map['comments'] = comments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  int compareTo(other) {
    // TODO: implement compareTo
    return timestamp.toDate().compareTo(other.timestamp.toDate());
  }
}

enum Type {
  text,
  image,
  video,
  audio,
}
