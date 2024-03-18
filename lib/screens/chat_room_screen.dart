import 'package:chat_app_mozz_test/core/constants.dart';
import 'package:chat_app_mozz_test/core/features.dart';
import 'package:chat_app_mozz_test/models/room.dart';
import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/repositories/message_repo.dart';
import 'package:chat_app_mozz_test/repositories/room_repo.dart';
import 'package:chat_app_mozz_test/repositories/user_repo.dart';
import 'package:chat_app_mozz_test/widgets/message_list_item.dart';
import 'package:chat_app_mozz_test/widgets/message_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    super.initState();

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
  final ScrollController _scrollController = ScrollController();
  Features features = Features();
  Constants constants = Constants();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String roomID = MessageRepository.getConversationId(widget.uid);

    return StreamBuilder(
      stream: UsersRepository.getSingleUserWithId(widget.uid),
      builder: (context, snapshot) {
        UserModel user = UserModel();
        if (snapshot.hasData) {
          user = UserModel.fromJson(snapshot.data);
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
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: user.status! ? Colors.green : Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              shadowColor: Colors.grey,
            ),
            body: GestureDetector(
              child: StreamBuilder(
                  stream: ChatRoomsRepository.getChatRoom(roomID),
                  builder: (context, roomSnapshot) {
                    ChatRooms chatRooms = ChatRooms(
                      id: roomSnapshot.data?['id'],
                      messageIDList: roomSnapshot.data?['message_id_list'] != null ? List<String>.from(roomSnapshot.data?['message_id_list']) : [],
                    );
                    switch (roomSnapshot.connectionState) {
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (chatRooms.messageIDList!.isNotEmpty) {
                          return MessageListItem(
                            messageIdList: chatRooms.messageIDList,
                            uid: widget.uid,
                          );
                        }
                      default:
                        return Container();
                    }
                    return Container();
                  }),
            ),
            bottomSheet: MessageTextField(
              userModel: user,
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
