import 'package:chat_app_mozz_test/core/constants.dart';
import 'package:chat_app_mozz_test/core/features.dart';
import 'package:chat_app_mozz_test/models/message.dart';
import 'package:chat_app_mozz_test/repositories/auth_repo.dart';
import 'package:chat_app_mozz_test/repositories/message_repo.dart';
import 'package:chat_app_mozz_test/widgets/message.dart';
import 'package:chat_app_mozz_test/widgets/message_group_header_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';

class MessageListItem extends StatefulWidget {
  const MessageListItem({super.key, required this.messageIdList, required this.uid});

  final List<String>? messageIdList;
  final String uid;

  @override
  State<MessageListItem> createState() => _MessageListItemState();
}

class _MessageListItemState extends State<MessageListItem> {
  final ScrollController _scrollController = ScrollController();
  Features features = Features();
  Constants constants = Constants();
  final List<Messages> _listMessages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return StreamBuilder(
      stream: MessageRepository.getAllMessages(widget.messageIdList!),
      builder: (context, snapshot) {
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
            final data = snapshot.data;
            for (var element in data!) {
              Messages message = Messages.fromJson(element);
              _listMessages.add(message);
            }
            for (Messages message in _listMessages) {
              if (!message.isRead && message.senderId != AuthRepository.user.uid) {
                MessageRepository.updateMessageStatus(true, message.id);
              }
            }
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
    );
  }
}
