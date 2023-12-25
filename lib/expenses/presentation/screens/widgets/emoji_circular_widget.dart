import 'package:flutter/material.dart';

class EmojiCircularWidget extends StatelessWidget {
  const EmojiCircularWidget({
    super.key,
    required this.backgroundColor,
    required this.emoji,
  });

  final Color backgroundColor;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(
              fontSize: 20), // Ajusta el tamaño del emoji según tus necesidades
        ),
      ),
    );
  }
}
