import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {
  String yMMMd() => DateFormat.yMMMd('es_US').format(this);

  String monthText() => DateFormat.MMMM('es_US').format(this);

  get withoutHours => DateTime(year, month, day);

  String formatDateTitle() {
    final dateLocal = toLocal();
    final today = DateTime.now().toLocal().withoutHours;
    final difference = dateLocal.difference(today);

    return switch (difference) {
      Duration(inDays: 0) => 'Hoy',
      Duration(inDays: 1) => 'Mañana',
      Duration(inDays: -1) => 'Ayer',
      _ => yMMMd(),
    };
  }
}
