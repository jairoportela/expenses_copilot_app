import 'package:intl/intl.dart';

extension NumberFormatExtension on double {
  String toCOPFormat([decimalDigits = 0]) {
    return NumberFormat.currency(
      locale: 'es',
      decimalDigits: decimalDigits,
      customPattern: '\$###,###',
    ).format(this);
  }
}
