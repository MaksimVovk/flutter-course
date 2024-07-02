import 'package:flutter/material.dart';
import 'package:second_app/dice_roller.dart';
import 'package:second_app/styled_text.dart';

class GradientContainer extends StatelessWidget {
  final List<Color> colors;
  const GradientContainer(this.colors, {super.key});
  // GradientContainer() {
  //   // initialization
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: const Center(
        child: DiceRoller(),
        // child: StyledText('Hello!'),
      ),
    );
  }
}
