import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_mozz_test/core/features.dart';
import 'package:chat_app_mozz_test/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';

class ChatRoomScreen extends StatefulWidget {
  final BuildContext context;
  final String uid;
  final int colorIndex;

  const ChatRoomScreen({
    super.key,
    required this.context,
    required this.uid,
    required this.colorIndex,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  Features features = Features();
  Constants constants = Constants();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        User user = User();
        if (snapshot.hasData) {
          for (var document in snapshot.data!.docs) {
            Map<String, dynamic> userData = document.data();
            if (document.exists) {
              // User document exists
              // Create a User object from the user data
              user = User.fromMap(userData);
            }
          }

          print(user.username);
          print(user.status);
          print(user.id);
          print(user.lastMessageTime);
          print(user.chatRooms);
          print(user.image);
          print(user.phoneNumber);
          print(user.lastActivity);
          print(user.registrationDate);

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
                    backgroundColor: constants.leadingColor(widget.colorIndex),
                    child: user.image != null
                        ? CachedNetworkImage(imageUrl: user.image!)
                        : Text(
                            features.leading(user.username.toString()),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        user.status!,
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
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: .3))),
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
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
