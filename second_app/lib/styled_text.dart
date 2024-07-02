import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;

  const StyledText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color.fromARGB(255, 0, 58, 93),
        fontSize: 36.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
