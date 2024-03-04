import 'package:intl/intl.dart';

class Features {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat _timeFormat = DateFormat('Hm');

  String leading(String title) => _leading(title);

  String getLastMessageTime(DateTime dateTime) => _getLastMessageTime(dateTime);

  bool getCompareMessageDay(DateTime dateTime) => _getCompareMessageDay(dateTime);

  String messageTimeFormat(DateTime dateTime) => _messageTimeFormat(dateTime);

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

  String _getLastMessageTime(DateTime dateTime) {
    if (dateTime.day == DateTime.now().day && dateTime.month == DateTime.now().month && dateTime.year == DateTime.now().year) {
      print(DateTime.now().millisecondsSinceEpoch);
      print(dateTime.millisecondsSinceEpoch);
      return _timeFormat.format(dateTime).toString();
    } else {
      return _dateFormat.format(dateTime).toString();
    }
  }

  bool _getCompareMessageDay(DateTime dateTime) {
    if (dateTime.day != DateTime.now().day || dateTime.month != DateTime.now().month || dateTime.year != DateTime.now().year) {
      return true;
    }
    return false;
  }

  String _messageTimeFormat(DateTime dateTime) {
    return _timeFormat.format(dateTime).toString();
  }

  // function to convert time stamp to date
  static DateTime returnDateAndTimeFormat(String time) {
    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    var originalDate = DateFormat('MM/dd/yyyy').format(dt);
    return DateTime(dt.year, dt.month, dt.day);
  }

  //function to return message time in 24 hours format AM/PM
  static String messageTime(String time) {
    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    String difference = '';
    difference = DateFormat('jm').format(dt).toString();
    return difference;
  }

  // function to return date if date changes based on your local date and time
  static String groupMessageDateAndTime(String time) {
    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    var originalDate = DateFormat('MM/dd/yyyy').format(dt);

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
}
