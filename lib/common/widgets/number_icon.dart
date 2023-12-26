import 'package:flutter/material.dart';

class NumberIcons {
  static IconData getIconByNumber(int iconCodePoint) =>
      IconData(iconCodePoint, fontFamily: 'MaterialIcons');
}
