/// id : "room1"
/// name : "General Chat"
/// created_at : "2024-02-09T10:00:00"
/// last_message_time : "2024-02-09T11:45:00"
/// users : ["user1","user2"]
/// messages : [{"id":"msg1","sender_id":"user1","content":"Hello, everyone!","timestamp":"2024-02-09T11:30:00","type":"text","comments":[{"id":"comment1","sender_id":"user2","content":"Nice to meet you!","timestamp":"2024-02-09T11:35:00"}]},{"id":"msg2","sender_id":"user2","content":"Hi John!","timestamp":"2024-02-09T11:45:00","type":"audio","audio_duration":60,"comments":[{"id":"comment2","sender_id":"user1","content":"This is a nice audio!","timestamp":"2024-02-09T11:50:00"}]},{"id":"msg3","sender_id":"user3","content":"Hey there!","timestamp":"2024-02-09T12:00:00","type":"file","file_info":{"id":"file1","filename":"document.pdf","size":1024},"comments":[{"id":"comment3","sender_id":"user1","content":"Thanks for sharing!","timestamp":"2024-02-09T12:05:00"}]}]

class ChatRooms {
  ChatRooms({
    this.id,
    this.messageIDList,
  });

  ChatRooms.fromJson(dynamic json) {
    id = json['id'];
    messageIDList = json['message_id_list'] != null ? List<String>.from(json['message_id_list']) : [];
  }

  String? id;
  List<String>? messageIDList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (messageIDList != null) {
      map['message_id_list'] = messageIDList?.map((v) => v).toList();
    }
    return map;
  }
}
