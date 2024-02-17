/// id : "comment1"
/// sender_id : "user2"
/// content : "Nice to meet you!"
/// timestamp : "2024-02-09T11:35:00"

class Comments {
  Comments({
    this.id,
    this.senderId,
    this.content,
    this.timestamp,
  });

  Comments.fromJson(dynamic json) {
    id = json['id'];
    senderId = json['sender_id'];
    content = json['content'];
    timestamp = json['timestamp'];
  }

  String? id;
  String? senderId;
  String? content;
  String? timestamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sender_id'] = senderId;
    map['content'] = content;
    map['timestamp'] = timestamp;
    return map;
  }
}
