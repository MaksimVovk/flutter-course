import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:third_app/data/questions.dart';
import 'package:third_app/question_summary.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen(
      {required this.restart, required this.chosenAnswers, super.key});
  final List<String> chosenAnswers;
  final void Function() restart;

  List<Map<String, Object>> get summaryData {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      final Map<String, Object> patch = {
        'question_index': i,
        'question': questions[i].text,
        'correct_answer': questions[i].answers[0],
        'user_answer': chosenAnswers[i],
        'is_correct': questions[i].answers[0] == chosenAnswers[i]
      };
      summary.add(patch);
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final numTotalQuestions = questions.length;
    final correctQuestions =
        summaryData.where((it) => it['is_correct'] as bool).length;
    final isAllCorrect = numTotalQuestions == correctQuestions;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 223, 255, 251),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  const TextSpan(text: 'You answered '),
                  TextSpan(
                    text: '$correctQuestions',
                    style: TextStyle(
                      color: isAllCorrect
                          ? const Color.fromARGB(255, 17, 255, 112)
                          : correctQuestions > 0
                              ? const Color.fromARGB(255, 255, 140, 17)
                              : const Color.fromARGB(255, 255, 17, 17),
                    ),
                  ),
                  const TextSpan(text: ' out of '),
                  TextSpan(
                    text: '$numTotalQuestions',
                    style:
                        const TextStyle(color: Color.fromARGB(255, 51, 5, 255)),
                  ),
                  const TextSpan(text: ' questions correctly!'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            QuestionSummary(data: summaryData),
            const SizedBox(height: 30),
            TextButton.icon(
              icon: const Icon(Icons.refresh),
              onPressed: restart,
              label: const Text(
                'Restart quiz',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
            )
          ],
        ),
      ),
    );
  }
}
