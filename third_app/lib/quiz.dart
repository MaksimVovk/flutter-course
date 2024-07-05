import 'package:flutter/material.dart';
import 'package:third_app/data/questions.dart';
import 'package:third_app/questions_sceen.dart';
import 'package:third_app/results_screen.dart';
import 'package:third_app/start_screen.dart';

const colors = [
  Color.fromARGB(255, 51, 227, 115),
  Color.fromARGB(255, 116, 184, 240)
];

class Quiz extends StatefulWidget {
  const Quiz({super.key});
  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  // Widget? activeScreen;
  var activeScreen = 'start-screen';
  List<String> selectedAnswers = [];

  // @override
  // void initState() {
  //   activeScreen = StartScreen(switchScreen);
  //   super.initState();
  // }

  void switchScreen() {
    setState(() {
      // activeScreen = const QuestionsSceen();
      activeScreen = 'question-screen';
    });
  }

  void restart() {
    setState(() {
      selectedAnswers = [];
      activeScreen = 'question-screen';
    });
  }

  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);
    if (questions.length == selectedAnswers.length) {
      setState(() {
        activeScreen = 'result-screen';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = StartScreen(switchScreen);

    if (activeScreen == 'question-screen') {
      screenWidget = QuestionsSceen(emit: chooseAnswer);
    } else if (activeScreen == 'result-screen') {
      screenWidget = ResultsScreen(
        chosenAnswers: selectedAnswers,
        restart: restart,
      );
    }
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
