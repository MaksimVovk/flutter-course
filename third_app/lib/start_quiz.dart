import 'package:flutter/material.dart';

class StartQuiz extends StatelessWidget {
  final void Function()? emit;
  const StartQuiz({this.emit, super.key});
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = OutlinedButton.styleFrom(
      // textStyle: const TextStyle(fontSize: 20),
      foregroundColor: Colors.white,
    );
    return OutlinedButton.icon(
      style: style,
      onPressed: emit ?? () {},
      icon: const Icon(Icons.arrow_right_alt),
      label: const Text('Start Quiz'),
    );
  }
}
