import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionSummary extends StatelessWidget {
  const QuestionSummary({required this.data, super.key});

  final List<Map<String, Object>> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: data.map((it) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: (it['is_correct'] as bool)
                        ? const Color.fromARGB(255, 139, 255, 143)
                        : const Color.fromARGB(255, 255, 90, 78),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ((it['question_index'] as int) + 1).toString(),
                        style: GoogleFonts.lato(
                          color: const Color.fromARGB(255, 20, 15, 30),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textAlign: TextAlign.left,
                        it['question'] as String,
                        style: GoogleFonts.lato(
                          color: const Color.fromARGB(255, 223, 255, 251),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        it['user_answer'] as String,
                        style: TextStyle(
                          color: (it['is_correct'] as bool)
                              ? Color.fromARGB(255, 0, 171, 6)
                              : Color.fromARGB(255, 207, 14, 0),
                          fontSize: 14,
                        ),
                      ),
                      Text(it['correct_answer'] as String,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 3, 164),
                            fontSize: 14,
                          )),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
