import 'package:flutter/material.dart';
import 'package:third_app/answer_button.dart';
import 'package:third_app/data/questions.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsSceen extends StatefulWidget {
  const QuestionsSceen({required this.emit, super.key});
  final void Function(String answer) emit;
  @override
  State<QuestionsSceen> createState() {
    return _QuestionsSceenState();
  }
}

class _QuestionsSceenState extends State<QuestionsSceen> {
  var currentQuestionIndex = 0;

  void handleAnswer(String text) {
    widget.emit(text);
    if (currentQuestionIndex + 1 >= questions.length) {
      return;
    }
    setState(() {
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestions = questions[currentQuestionIndex];
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              currentQuestions.text,
              style: GoogleFonts.lato(
                fontSize: 22,
                color: const Color.fromARGB(255, 207, 255, 247),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ...currentQuestions.getShuffledAnswers().map((it) {
              return AnswerButton(
                text: it,
                emit: handleAnswer,
              );
            }),
          ],
        ),
      ),
    );
  }
}
