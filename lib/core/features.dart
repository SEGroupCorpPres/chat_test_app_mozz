import 'package:intl/intl.dart';

class Features {

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat _timeFormat = DateFormat('Hm');

  String leading(String title) => _leading(title);
  String getLastMessageTime(DateTime dateTime) => _getLastMessageTime(dateTime);
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
    if (dateTime.day < DateTime.now().day) {
      return _dateFormat.format(dateTime).toString();
    } else {
      return _timeFormat.format(dateTime).toString();
    }
  }
}