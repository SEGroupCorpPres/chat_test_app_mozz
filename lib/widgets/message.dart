import 'package:chat_app_mozz_test/core/features.dart';
import 'package:chat_app_mozz_test/models/message.dart';
import 'package:chat_app_mozz_test/models/message_type.dart';
import 'package:chat_app_mozz_test/repositories/auth_repo.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Message extends StatefulWidget {
  const Message({
    super.key,
    required this.messages,
    required this.messageType,
    required this.index,
  });

  final Messages messages;
  final MessageType messageType;
  final int index;

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  Features features = Features();
  late final MessageType type = widget.messageType;
  late final int index = widget.index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('$index $type   ${widget.messages.content}');
  }

  Widget _senderMessage() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              type == MessageType.first
                  ? Container()
                  : type == MessageType.middle
                      ? Container()
                      : Container(
                          height: 20.h,
                          width: 30.w,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.r),
                            ),
                          ),
                        ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).r,
                    decoration: _getSenderMessageDecoration(),
                    child: Column(
                      children: [
                        widget.messages.type == Type.image
                            ? Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 200),
                                decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.messages.content.toString()), fit: BoxFit.fitWidth)),
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 200),
                              child: Text(
                                widget.messages.type == Type.image ? widget.messages.comments.toString() : widget.messages.content,
                                softWrap: true,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Row(
                              children: [
                                Text(features.messageTimeFormat(widget.messages.timestamp.toDate())),
                                SizedBox(width: 3.w),
                                Icon(
                                  widget.messages.isRead ? Icons.done_all : Icons.check,
                                  size: 15.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 10.w,
                    height: 30.5.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: const Radius.elliptical(10, 18).r,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  Widget _recipientMessage() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              type == MessageType.first
                  ? Container()
                  : type == MessageType.middle
                      ? Container()
                      : Container(
                          height: 20.h,
                          width: 30.w,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10.r),
                            ),
                          ),
                        ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 10.w,
                    height: 30.5.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: const Radius.elliptical(10, 18).r,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).r,
                    decoration: _getRecipientMessageDecoration(),
                    child: Column(
                      children: [
                        widget.messages.type == Type.image
                            ? GestureDetector(
                                onTap: () {
                                  final imageProvider = Image.network(widget.messages.content).image;
                                  showImageViewer(
                                    context,
                                    imageProvider,
                                    onViewerDismissed: () {
                                      print("dismissed");
                                    },
                                    swipeDismissible: true,
                                    backgroundColor: Colors.transparent,
                                  );
                                },
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 200, maxHeight: 300),
                                  decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.messages.content), fit: BoxFit.cover)),
                                ),
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 200),
                              child: Text(
                                widget.messages.type == Type.image ? widget.messages.comments.toString() : widget.messages.content,
                                softWrap: true,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Row(
                              children: [
                                Text(features.messageTimeFormat(widget.messages.timestamp.toDate())),
                                SizedBox(width: 3.w),
                                Icon(
                                  widget.messages.isRead ? Icons.done_all : Icons.check,
                                  size: 15.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AuthRepository.user.uid == widget.messages.senderId ? _senderMessage() : _recipientMessage();
  }

  BoxDecoration _getSenderMessageDecoration() {
    switch (type) {
      case MessageType.first:
        return BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(8),
            bottomLeft: Radius.circular(20),
          ).r,
        );
      case MessageType.middle:
        return BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
            bottomLeft: Radius.circular(20),
          ).r,
        );
      case MessageType.last:
        return BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(20),
          ).r,
        );
      case MessageType.separately:
        return BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(20),
          ).r,
        );
    }
  }

  BoxDecoration _getRecipientMessageDecoration() {
    switch (type) {
      case MessageType.first:
        return BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(8),
          ).r,
        );
      case MessageType.middle:
        return BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(8),
          ).r,
        );
      case MessageType.last:
        return BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(0),
          ).r,
        );
      case MessageType.separately:
        return BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(0),
          ).r,
        );
    }
  }
}
