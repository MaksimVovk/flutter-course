import 'package:flutter/material.dart';
import 'package:third_app/image_container.dart';
import 'package:third_app/start_quiz.dart';
import 'package:third_app/title.dart';

class StartScreen extends StatelessWidget {
  final void Function() emit;
  const StartScreen(this.emit, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ImageContainer('assets/images/quiz-logo.png'),
          const SizedBox(
            height: 80,
          ),
          const TitleWidget('Learn Flutter the fun way!'),
          const SizedBox(
            height: 30,
          ),
          StartQuiz(
            emit: emit,
          )
        ],
      ),
    );
  }
}
