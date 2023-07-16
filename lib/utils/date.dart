import 'package:intl/intl.dart';

String getToday() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var strToday = formatter.format(now);
  return strToday;
}
