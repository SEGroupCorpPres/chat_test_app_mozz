import 'package:chat_app_mozz_test/core/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupHeaderDate extends StatelessWidget {
  final DateTime date;

  const GroupHeaderDate({required this.date, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(alignment: Alignment.center, children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          color: Colors.grey,
          height: .5.h,
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            Features().getLastMessageTime(date),
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    );
  }
}