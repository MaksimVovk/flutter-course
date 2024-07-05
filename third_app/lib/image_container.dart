import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final String img;

  const ImageContainer(this.img, {super.key});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      color: const Color.fromARGB(150, 255, 255, 255),
      img,
      width: 300,
    );
  }
}
