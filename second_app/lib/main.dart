import 'package:flutter/material.dart';
import 'package:second_app/gradient_container.dart';

const gradientColors = [
  Color.fromARGB(255, 223, 243, 248),
  Color.fromARGB(255, 253, 241, 232)
];

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        // backgroundColor: Color(0xFF003A5D),
        body: GradientContainer(gradientColors),
      ),
    ),
  );
}
