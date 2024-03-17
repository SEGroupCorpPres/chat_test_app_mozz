import 'package:chat_app_mozz_test/core/constants.dart';
import 'package:chat_app_mozz_test/core/features.dart';
import 'package:chat_app_mozz_test/models/message.dart';
import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/repositories/message_repo.dart';
import 'package:chat_app_mozz_test/screens/chat_room_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatListTile extends StatefulWidget {
  const ChatListTile({super.key, required this.user, required this.colorIndex, required this.lastMessageId});

  final UserModel user;
  final int colorIndex;
  final String? lastMessageId;

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  Features features = Features();

  Constants constants = Constants();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget buildLastMessage(Messages message) {
    if (message.type == Type.text) {
      return Text(message.content);
    } else if (message.type == Type.image) {
      return Container(
        width: 30,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(message.content), fit: BoxFit.cover),
        ),
      );
    }
    return Container();
  }

  Widget buildMessageReadStatus(String id, bool isRead) {
    if (id != widget.user.id) {
      return Container();
    } else {
      if (isRead) {
        return const Icon(
          Icons.done_all,
          size: 13,
          color: CupertinoColors.activeGreen,
        );
      } else {
        return const Icon(
          Icons.check,
          size: 13,
          color: Colors.grey,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      enabled: true,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoomScreen(
            context: context,
            uid: widget.user.id!,
            colorIndex: widget.colorIndex,
          ),
        ),
      ),
      leading: widget.user.image != null
          ? CircleAvatar(
              radius: 30.r,
              backgroundImage: NetworkImage(widget.user.image!),
            )
          : CircleAvatar(
              radius: 30.r,
              backgroundColor: constants.leadingColor(widget.colorIndex),
              child: Text(
                features.leading(widget.user.username.toString()),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
            ),
      title: Text(
        widget.user.username.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: widget.lastMessageId != null
          ? StreamBuilder(
              stream: MessageRepository.getMessage(widget.lastMessageId!),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    Messages lastMessage = Messages.fromJson(snapshot.data);
                    return Row(
                      children: [
                        Text(lastMessage.recipientId != widget.user.id ? '' : 'Вы: '),
                        buildLastMessage(lastMessage),
                        const SizedBox(width: 10),
                        buildMessageReadStatus(lastMessage.recipientId, lastMessage.isRead),
                      ],
                    );
                  default:
                    return Container();
                }
              },
            )
          : Container(),
      trailing: widget.lastMessageId != null
          ? ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: StreamBuilder(
                stream: MessageRepository.getMessage(widget.lastMessageId!),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                    case ConnectionState.done:
                      Messages lastMessage = Messages.fromJson(snapshot.data);
                      return Column(
                        children: [
                          Text(
                            features.getLastMessageTime(lastMessage.timestamp.toDate()),
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ],
                      );
                    default:
                      return Container();
                  }
                },
              ),
            )
          : ConstrainedBox(constraints: const BoxConstraints(maxWidth: 100)),
    );
  }
}
