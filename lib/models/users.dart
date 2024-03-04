import 'package:chat_app_mozz_test/models/user.dart';

/// users : [{"id":"user1","username":"john_doe","phone_number":"+998901234567","registration_date":"2024-02-09","last_activity":"2024-02-09T12:30:00","chat_rooms":[{"id":"room1","name":"General Chat","created_at":"2024-02-09T10:00:00","last_message_time":"2024-02-09T11:45:00","messages":[{"id":"msg1","sender_id":"user1","content":"Hello, everyone!","timestamp":"2024-02-09T11:30:00","type":"text","comments":[{"id":"comment1","sender_id":"user2","content":"Nice to meet you!","timestamp":"2024-02-09T11:35:00"},null]},{"id":"msg2","sender_id":"user2","content":"Hi John!","timestamp":"2024-02-09T11:45:00","type":"audio","audio_duration":60,"comments":[{"id":"comment2","sender_id":"user1","content":"This is a nice audio!","timestamp":"2024-02-09T11:50:00"},null]},{"id":"msg3","sender_id":"user3","content":"Hey there!","timestamp":"2024-02-09T12:00:00","type":"file","file_info":{"id":"file1","filename":"document.pdf","size":1024},"comments":[{"id":"comment3","sender_id":"user1","content":"Thanks for sharing!","timestamp":"2024-02-09T12:05:00"},null]}]},null],"last_sms_time":"2024-02-09T12:00:00"},null]

class Users {
  Users({
    this.users,
  });

  Users.fromJson(dynamic json) {
    if (json['users'] != null) {
      users = [];
      json['user'].forEach((v) {
        users?.add(UserModel.fromJson(v));
      });
    }
  }

  List<UserModel>? users;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (users != null) {
      map['users'] = users?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
