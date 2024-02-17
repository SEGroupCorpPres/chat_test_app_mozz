import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';

class ChatRoomScreen extends StatefulWidget {
  final BuildContext context;
  final int index;
  final int colorIndex;

  const ChatRoomScreen({
    super.key,
    required this.context,
    required this.index,
    required this.colorIndex,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          padding: EdgeInsets.zero,
        ),
        elevation: .1,
        backgroundColor: Colors.white,
        centerTitle: false,
        toolbarHeight: 70,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: leadingColor[widget.colorIndex],
              child: Text(
                leading(chatItems[widget.index]['title'].toString()),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatItems[widget.index]['title'].toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  'В сети',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        shadowColor: Colors.grey,
      ),
      body: Column(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: .3))
        ),
        width: size.width,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFEDF2F6),

              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.attach_file),
              ),
            ),
            Container(
              width: 220,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFFEDF2F6),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: InputBorder.none,
                  isDense: true,
                  fillColor: Colors.grey,
                  hoverColor: Colors.red,
                  focusColor: Colors.green,
                  hintText: 'Сообщение',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF2F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.mic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
