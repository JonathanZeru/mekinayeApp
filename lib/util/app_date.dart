import 'package:intl/intl.dart';

class AppDate {
  // Define a format for your dates
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  String format(DateTime date) {
    return _dateFormat.format(date);
  }
}
