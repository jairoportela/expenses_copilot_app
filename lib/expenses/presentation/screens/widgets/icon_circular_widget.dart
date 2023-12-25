import 'package:expenses_copilot_app/common/widgets/number_icon.dart';
import 'package:flutter/material.dart';

class IconCircularWidget extends StatelessWidget {
  const IconCircularWidget({
    super.key,
    required this.backgroundColor,
    required this.iconCodePoint,
  });

  final Color backgroundColor;
  final int iconCodePoint;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      radius: 25,
      child: Icon(
        NumberIcons.getIconByNumber(iconCodePoint),
        color: Colors.black,
      ),
    );
  }
}
