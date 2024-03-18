import 'dart:math';

import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/repositories/auth_repo.dart';
import 'package:chat_app_mozz_test/repositories/message_repo.dart';
import 'package:chat_app_mozz_test/repositories/user_repo.dart';
import 'package:chat_app_mozz_test/screens/chat_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final AuthRepository authRepository = AuthRepository();

  //
  final List<UserModel> _searchList = [];
  List<UserModel> _list = [];
  bool _isSearching = false;
  String lastMessageId = '';

  String uid = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUID();
    SystemChannels.lifecycle.setMessageHandler((message) {
      print('Message: $message');
      if (message.toString().contains('resume')) UsersRepository.updateUserStatus(true, uid);

      if (message.toString().contains('pause')) UsersRepository.updateUserStatus(false, uid);
      print(uid + '---> uid');
      return Future.value(message);
    });
  }

  Future<void> getUID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    uid = sharedPreferences.getString('uid')!;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: true,
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
              child: TextField(
                autofocus: false,
                onChanged: (value) {
                  _searchList.clear();
                  for (var i in _list) {
                    if (i.username!.toLowerCase().contains(value.toLowerCase())) {
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                      _isSearching = true;
                    });
                  }
                },
                decoration: const InputDecoration(
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
              stream: UsersRepository.getAllUsers(),
              builder: (context, snapshot) {
                List<UserModel> userList = [];
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
                    userList = _isSearching ? _searchList : _list;
                    userList.sort((a, b) => b.lastMessageTime!.millisecondsSinceEpoch.compareTo(a.lastMessageTime!.millisecondsSinceEpoch));
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _isSearching ? _searchList.length : userList.length,
                      itemBuilder: (BuildContext context, int index) {
                        random = Random().nextInt(16);
                        final String roomId = MessageRepository.getConversationId(userList[index].id!);
                        return Column(
                          children: [
                            index == 0
                                ? Divider(
                                    indent: 20,
                                    endIndent: 20,
                                    thickness: 1,
                                    color: Colors.grey.shade200,
                                  )
                                : Container(),
                            StreamBuilder(
                              stream: MessageRepository.getLastMessageId(roomId),
                              builder: (context, messageIDSnapshot) {
                                switch (messageIDSnapshot.connectionState) {
                                  case ConnectionState.active:
                                  case ConnectionState.done:
                                    return ChatListTile(user: userList[index], colorIndex: random!, lastMessageId: messageIDSnapshot.data);
                                  case ConnectionState.none:
                                  default:
                                    return ChatListTile(user: userList[index], colorIndex: random!, lastMessageId: messageIDSnapshot.data);
                                }
                              },
                            ),
                            index == userList.length - 1
                                ? Divider(
                                    indent: 20,
                                    endIndent: 20,
                                    thickness: 1,
                                    color: Colors.grey.shade200,
                                  )
                                : Container(),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => Divider(
                        indent: 20,
                        endIndent: 20,
                        thickness: 1,
                        color: Colors.grey.shade200,
                      ),
                    );
                  default:
                    return Container();
                }
              },
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  int? random;
}
