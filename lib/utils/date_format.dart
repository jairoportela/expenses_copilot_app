import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {
  yMMMd() => DateFormat.yMMMd().format(this);
}
