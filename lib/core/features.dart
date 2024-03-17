import 'package:chat_app_mozz_test/models/message.dart';
import 'package:chat_app_mozz_test/models/message_type.dart';
import 'package:intl/intl.dart';

class Features {
  // Date format for displaying dates
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  // Time format for displaying times
  final DateFormat _timeFormat = DateFormat('Hm');

  // Method to extract leading character from a title
  String leading(String title) => _leading(title);

  // Method to format last message time
  String getLastMessageTime(DateTime dateTime) => _getLastMessageTime(dateTime);

  // Method to compare message date with current date
  bool getCompareMessageDay(DateTime dateTime) => _getCompareMessageDay(dateTime);

  // Method to format message time
  String messageTimeFormat(DateTime dateTime) => _messageTimeFormat(dateTime);

  // Method to determine the message type based on its position in the list
  MessageType getMessageType(List<Messages> listMessage, int currentIndex, String uid) => _getMessageType(listMessage, currentIndex, uid);

  // Private method to extract leading character from a title
  String _leading(String title) {
    if (title.contains(' ')) {
      List title0 = title.split('');
      int idxSp = title.indexOf(' ');
      String leading = title0.first + title0[idxSp].toString().toUpperCase();
      return leading;
    } else {
      return title[0].toUpperCase();
    }
  }

  // Private method to format last message time
  String _getLastMessageTime(DateTime dateTime) {
    if (dateTime.day == DateTime.now().day && dateTime.month == DateTime.now().month && dateTime.year == DateTime.now().year) {
      return _timeFormat.format(dateTime).toString();
    } else {
      return _dateFormat.format(dateTime).toString();
    }
  }

  // Private method to compare message date with current date
  bool _getCompareMessageDay(DateTime dateTime) {
    if (dateTime.day != DateTime.now().day || dateTime.month != DateTime.now().month || dateTime.year != DateTime.now().year) {
      return true;
    }
    return false;
  }

  // Private method to format message time
  String _messageTimeFormat(DateTime dateTime) {
    return _timeFormat.format(dateTime).toString();
  }

  // Static method to convert timestamp to date
  static DateTime returnDateAndTimeFormat(String time) {
    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    return DateTime(dt.year, dt.month, dt.day);
  }

  // Static method to format message time in 12-hour format
  static String messageTime(String time) {
    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    String difference = '';
    difference = DateFormat('jm').format(dt).toString();
    return difference;
  }

  // Static method to format group message date and time
  static String groupMessageDateAndTime(String time) {
    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    DateFormat('MM/dd/yyyy').format(dt);

    final todayDate = DateTime.now();

    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
    final yesterday = DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
    String difference = '';
    final aDate = DateTime(dt.year, dt.month, dt.day);

    if (aDate == today) {
      difference = "Today";
    } else if (aDate == yesterday) {
      difference = "Yesterday";
    } else {
      difference = DateFormat.yMMMd().format(dt).toString();
    }

    return difference;
  }

  // Method to determine the type of message based on its position in the message list
  MessageType _getMessageType(List<Messages> listMessage, int currentIndex, String uid) {
    listMessage = listMessage.reversed.toList(); // Reverse the message list to simplify indexing
    int length = listMessage.length;
    // Check if the current message is the last message in the list
    if (currentIndex == length - 1) {
      return _getCurrentIndexAndListLengthIsEqual(listMessage, currentIndex, uid);
    }
    // Check if the current message is not the last message in the list
    else if (currentIndex + 1 <= length - 1) {
      // If the current message is the first message in the list
      if (currentIndex == 0) {
        return _getCurrentIndexIsEqualZero(listMessage, currentIndex, uid);
      }
      // If the current message is not the first or last message in the list
      else {
        return _getCurrentIndexHigherZeroAndLessThenListLength(listMessage, currentIndex, uid);
      }
    }
    // If the current message is the last message in the list
    else {
      return MessageType.last;
    }
  }

  // Helper method to check if the date of the current message is different from the date of the previous message
  bool _getMessageCurrentAndPreviousDateNotEqual(List<Messages> listMessage, int currentIndex) {
    // Compare the dates of the current and previous messages
    if (listMessage[currentIndex].timestamp.toDate().day != listMessage[currentIndex - 1].timestamp.toDate().day ||
        listMessage[currentIndex].timestamp.toDate().month != listMessage[currentIndex - 1].timestamp.toDate().month ||
        listMessage[currentIndex].timestamp.toDate().year != listMessage[currentIndex - 1].timestamp.toDate().year) {
      return true; // Return true if the dates are different
    }
    return false; // Return false if the dates are the same
  }

  // Helper method to check if the date of the current message is different from the date of the next message
  bool _getMessageCurrentAndNextDateNotEqual(List<Messages> listMessage, int currentIndex) {
    // Compare the dates of the current and next messages
    if (listMessage[currentIndex].timestamp.toDate().day != listMessage[currentIndex + 1].timestamp.toDate().day ||
        listMessage[currentIndex].timestamp.toDate().month != listMessage[currentIndex + 1].timestamp.toDate().month ||
        listMessage[currentIndex].timestamp.toDate().year != listMessage[currentIndex + 1].timestamp.toDate().year) {
      return true; // Return true if the dates are different
    }
    return false; // Return false if the dates are the same
  }

  // Helper method to determine the message type when the current index is the last message and the list length is reached
  MessageType _getCurrentIndexAndListLengthIsEqual(List<Messages> listMessage, int currentIndex, String uid) {
    // Check if the last message belongs to the current user or the recipient
    if (listMessage[currentIndex].recipientId == uid) {
      // If the last message belongs to the current user
      // Check if the previous message belongs to a different user
      if (listMessage[currentIndex - 1].recipientId != uid) {
        return MessageType.separately; // Return separately if the previous message belongs to a different user
      }
      return MessageType.first; // Return first if the last message belongs to the same user as the previous message
    }
    // If the last message belongs to the recipient
    else if (listMessage[currentIndex].recipientId != uid) {
      // Check if the previous message belongs to the current user
      if (listMessage[currentIndex - 1].recipientId == uid) {
        return MessageType.separately; // Return separately if the previous message belongs to the current user
      }
      return MessageType.first; // Return first if the last message belongs to the same recipient as the previous message
    } else {
      return MessageType.last; // Return last if the last message is the end of the conversation
    }
  }

  // Helper method to determine the message type when the current index is 0
  MessageType _getCurrentIndexIsEqualZero(List<Messages> listMessage, int currentIndex, String uid) {
    // Check if the first message belongs to the current user or the recipient
    if (listMessage[currentIndex].recipientId == uid) {
      // If the first message belongs to the current user
      // Check if the next message belongs to a different user
      if (listMessage[currentIndex + 1].recipientId != uid) {
        return MessageType.separately; // Return separately if the next message belongs to a different user
      }

      return MessageType.last; // Return last if the next message belongs to the same user
    }
    // If the first message belongs to the recipient
    else if (listMessage[currentIndex].recipientId != uid) {
      // Check if the next message belongs to the current user
      if (listMessage[currentIndex + 1].recipientId == uid) {
        return MessageType.separately; // Return separately if the next message belongs to the current user
      }
      return MessageType.last; // Return last if the next message belongs to the same recipient
    } else {
      return MessageType.first; // Return first if the first message is the start of the conversation
    }
  }

  // Helper method to determine the message type when the current index is greater than 0 and less than the list length
  MessageType _getCurrentIndexHigherZeroAndLessThenListLength(List<Messages> listMessage, int currentIndex, String uid) {
    // Check various scenarios of message types based on the positions and relationships of neighboring messages
    if (listMessage[currentIndex].recipientId == uid && listMessage[currentIndex - 1].recipientId == uid && listMessage[currentIndex + 1].recipientId == uid) {
      if (_getMessageCurrentAndNextDateNotEqual(listMessage, currentIndex)) {
        if (_getMessageCurrentAndPreviousDateNotEqual(listMessage, currentIndex)) {
          return MessageType.separately;
        }
        return MessageType.first;
      } else {
        if (_getMessageCurrentAndPreviousDateNotEqual(listMessage, currentIndex)) {
          return MessageType.last;
        } else {
          return MessageType.middle;
        }
      }
    } else if (listMessage[currentIndex].recipientId == uid && listMessage[currentIndex - 1].recipientId == uid && listMessage[currentIndex + 1].recipientId != uid) {
      if (_getMessageCurrentAndPreviousDateNotEqual(listMessage, currentIndex)) {
        return MessageType.separately;
      } else {
        return MessageType.first;
      }
    } else if (listMessage[currentIndex].recipientId == uid && listMessage[currentIndex - 1].recipientId != uid && listMessage[currentIndex + 1].recipientId != uid) {
      return MessageType.separately;
    } else if (listMessage[currentIndex].recipientId == uid && listMessage[currentIndex - 1].recipientId != uid) {
      if (_getMessageCurrentAndNextDateNotEqual(listMessage, currentIndex)) {
        return MessageType.separately;
      } else {
        return MessageType.last;
      }
    } else if (listMessage[currentIndex].recipientId != uid && listMessage[currentIndex - 1].recipientId != uid && listMessage[currentIndex + 1].recipientId != uid) {
      if (_getMessageCurrentAndNextDateNotEqual(listMessage, currentIndex)) {
        if (_getMessageCurrentAndPreviousDateNotEqual(listMessage, currentIndex)) {
          return MessageType.separately;
        }
        return MessageType.first;
      } else {
        if (_getMessageCurrentAndPreviousDateNotEqual(listMessage, currentIndex)) {
          return MessageType.last;
        } else {
          return MessageType.middle;
        }
      }
    } else if (listMessage[currentIndex].recipientId != uid && listMessage[currentIndex - 1].recipientId != uid && listMessage[currentIndex + 1].recipientId == uid) {
      if (_getMessageCurrentAndPreviousDateNotEqual(listMessage, currentIndex)) {
        return MessageType.separately;
      } else {
        return MessageType.first;
      }
    } else if (listMessage[currentIndex].recipientId != uid && listMessage[currentIndex - 1].recipientId == uid) {
      if (_getMessageCurrentAndNextDateNotEqual(listMessage, currentIndex)) {
        return MessageType.separately;
      }
      return MessageType.last;
    } else {
      return MessageType.separately;
    }
  }
}
