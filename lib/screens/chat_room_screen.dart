import 'package:chat_app_mozz_test/core/features.dart';
import 'package:chat_app_mozz_test/models/message.dart';
import 'package:chat_app_mozz_test/models/message_type.dart';
import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/repositories/message_repo.dart';
import 'package:chat_app_mozz_test/repositories/user_repo.dart';
import 'package:chat_app_mozz_test/widgets/message.dart';
import 'package:chat_app_mozz_test/widgets/message_group_header_date.dart';
import 'package:chat_app_mozz_test/widgets/message_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

enum UserType { sender, recipient }

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
  @override
  void initState() {
    // _scrollController.addListener(onUserScrolls);


  }

  bool keepFetchingData = true;

  // Completer<bool>? _scrollCompleter;
  // Future<void> onUserScrolls() async {
  //   if (!keepFetchingData) return;
  //   if (widget.onPageTopScrollFunction == null) return;
  //   if (!(_scrollCompleter?.isCompleted ?? true)) return;
  //
  //   double
  //   screenSize = MediaQuery.of(context).size.height,
  //       scrollLimit = _scrollController.position.maxScrollExtent,
  //       missingScroll = scrollLimit - screenSize,
  //       scrollLimitActivation = scrollLimit - missingScroll * 0.05;
  //
  //   if (_scrollController.position.pixels < scrollLimitActivation) return;
  //   if (!(_scrollCompleter?.isCompleted ?? true)) return;
  //
  //   _scrollCompleter = Completer();
  //   keepFetchingData = await widget.onPageTopScrollFunction!();
  //   _scrollCompleter!.complete(keepFetchingData);
  // }
  ScrollController _scrollController = ScrollController();
  Features features = Features();
  Constants constants = Constants();
  List<Messages> _listMessages = [];

  void _showBottomImagePicker() {
    // showModalBottomSheet()
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return StreamBuilder(
      stream: UsersRepository.getSingleUserWithId(widget.uid),
      builder: (context, snapshot) {
        UserModel user = UserModel();
        if (snapshot.hasData) {
          user = UserModel.fromJson(snapshot.data);

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
            backgroundColor: Colors.white,
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
                  user.image != null
                      ? CircleAvatar(
                          radius: 20.r,
                          backgroundImage: NetworkImage(user.image!),
                        )
                      : CircleAvatar(
                          radius: 20.r,
                          backgroundColor: constants.leadingColor(widget.colorIndex),
                          child: Text(
                            features.leading(user.username.toString()),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
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
                        user.status! ? 'online' : 'offline',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
              shadowColor: Colors.grey,
            ),
            body: GestureDetector(
              child: StreamBuilder(
                stream: MessageRepository.getAllMessages(user),
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
                      _listMessages = data?.map((message) => Messages.fromJson(message.data())).toList() ?? [];
                      return Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        radius: const Radius.circular(15),
                        child: SizedBox(
                          height: size.height - 100.h - kToolbarHeight.h,
                          child: GroupedListView<Messages, DateTime>(
                            controller: _scrollController,
                            elements: _listMessages,
                            groupBy: (Messages message) => DateTime(
                              message.timestamp.toDate().year,
                              message.timestamp.toDate().month,
                              message.timestamp.toDate().day,
                            ),
                            groupHeaderBuilder: (Messages message) => GroupHeaderDate(
                              date: message.timestamp.toDate(),
                            ),
                            groupComparator: (message1, message2) => message1.compareTo(message2),
                            sort: true,
                            reverse: true,
                            floatingHeader: true,
                            useStickyGroupSeparators: true,
                            indexedItemBuilder: (context, Messages element, int index) => Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Message(
                                messages: element,
                                messageType: features.getMessageType(_listMessages, index, widget.uid),
                                index: index,
                              ),
                            ),
                            itemComparator: (message1, message2) => message1.timestamp.compareTo(message2.timestamp),
                            order: GroupedListOrder.DESC, // optional
                          ),
                        ),
                      );
                    default:
                      return Container();
                  }
                },
              ),
            ),
            bottomSheet: MessageTextField(userModel: user,),
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
