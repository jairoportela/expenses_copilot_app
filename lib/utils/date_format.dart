import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {
  yMMMd() => DateFormat.yMMMd().format(this);

  String formatDateTitle() {
    final dateLocal = toLocal();
    final now = DateTime.now().toLocal();
    final DateTime today = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final difference = dateLocal.difference(today);

    return switch (difference) {
      Duration(inHours: final hours) when hours < 0 && hours >= -24 => 'Hoy',
      Duration(inHours: final hours) when hours >= 0 && hours <= 24 => 'Mañana',
      Duration(inHours: final hours, inDays: -1) when hours <= -24 => 'Ayer',
      _ => yMMMd(),
    };
  }
}
