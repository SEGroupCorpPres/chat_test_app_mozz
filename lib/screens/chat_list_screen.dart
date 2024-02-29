import 'dart:math';

import 'package:chat_app_mozz_test/core/features.dart';
import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/repositories/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final AuthRepository authRepository = AuthRepository();

  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  Features features = Features();
  Constants constants = Constants();

  String uid = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUID();
  }

  Future<void> getUID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    uid = sharedPreferences.getString('uid')!;
    print('$uid  init uid');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
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
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              List<User> userList = [];
              if (snapshot.hasData) {
                for (var document in snapshot.data!.docs) {
                  Map<String, dynamic> userData = document.data();
                  if (document.exists) {
                    // User document exists
                    // Create a User object from the user data
                    User user = User.fromMap(userData);
                    if (uid != user.id) {
                      userList.add(user);
                    } else {
                      continue;
                    }
                  }
                }
                return Column(children: [
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      random = Random().nextInt(16);
                      print(userList[index].image);
                      return ListTile(
                        dense: true,
                        enabled: true,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoomScreen(
                              context: context,
                              uid: userList[index].id!,
                              colorIndex: random!,
                            ),
                          ),
                        ),
                        leading: userList[index].image != null
                            ? CircleAvatar(
                                radius: 30.r,
                                backgroundImage: NetworkImage(userList[index].image!),
                              )
                            : CircleAvatar(
                                radius: 30.r,
                                backgroundColor: constants.leadingColor(random!),
                                child: Text(
                                  features.leading(userList[index].username.toString()),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                        title: Text(
                          userList[index].username.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(userList[index].chatRooms!.isNotEmpty ? userList[index].chatRooms!.last.messages.toString() : ''),
                        trailing: Column(
                          children: [
                            Text(
                              userList[index].lastMessageTime != null ? features.getLastMessageTime(userList[index].lastMessageTime!.toDate()) : '',
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
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                    thickness: 1,
                    color: Colors.grey.shade200,
                  ),
                ]);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  int? random;
}
