import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          shadowColor: Colors.grey,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: const Text(
            'Чаты',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size(size.width, 70),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFFEDF2F6),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: const TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  border: InputBorder.none,
                  isDense: true,
                  fillColor: Colors.grey,
                  hoverColor: Colors.red,
                  focusColor: Colors.green,
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    size: 30,
                    color: Colors.grey,
                  ),
                  hintText: 'Поиск',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: SizedBox(
            height: size.height - kToolbarHeight,
            child: Column(
              children: [
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    random = Random().nextInt(16);
                    return ListTile(
                      dense: true,
                      enabled: true,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoomScreen(context: context, index: index, colorIndex: random!,),
                        ),
                      ),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: leadingColor[random!],
                        child: Text(
                          leading(chatItems[index]['title'].toString()),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      title: Text(
                        chatItems[index]['title'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(chatItems[index]['subtitle'].toString()),
                      trailing: Column(
                        children: [
                          Text(
                            chatItems[index]['trailing'].toString(),
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(
                    indent: 20,
                    endIndent: 20,
                    thickness: 1,
                    color: Colors.grey.shade200,
                  ),
                  itemCount: chatItems.length,
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  thickness: 1,
                  color: Colors.grey.shade200,
                ),
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }



  int? random;
}
