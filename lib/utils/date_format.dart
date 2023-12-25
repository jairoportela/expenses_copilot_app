import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {
  yMMMd() => DateFormat.yMMMd().format(this);

  String formatDateTitle() {
    final today = DateTime.now().toUtc();
    final difference = this.difference(today);

    return switch (difference) {
      Duration(inDays: 0) => 'Hoy',
      Duration(inDays: 1) => 'Mañana',
      Duration(inDays: -1) => 'Ayer',
      _ => yMMMd(),
    };
  }
}
