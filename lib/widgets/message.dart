import 'package:chat_app_mozz_test/core/features.dart';
import 'package:chat_app_mozz_test/models/message.dart';
import 'package:chat_app_mozz_test/repositories/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key, required this.messages});

  final Messages messages;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Features features = Features();

  Widget _senderMessage() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 20.h,
                width: 30.w,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                        bottomLeft: Radius.circular(15.r),
                      ),
                      color: Colors.greenAccent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.messages.content,
                        ),
                        SizedBox(width: 10.w),
                        Text(features.messageTimeFormat(widget.messages.timestamp.toDate())),
                        SizedBox(width: 3.w),
                        Icon(
                          widget.messages.isRead ? Icons.done_all : Icons.check,
                          size: 15.sp,
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
              Container(
                height: 20.h,
                width: 30.w,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              Row(
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                        bottomRight: Radius.circular(15.r),
                      ),
                      color: Colors.greenAccent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.messages.content,
                        ),
                        SizedBox(width: 10.w),
                        Text(features.messageTimeFormat(widget.messages.timestamp.toDate())),
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
}
