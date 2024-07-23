import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onSelectImage});
  final void Function(File image) onSelectImage;

  @override
  State<ImageInput> createState() {
    return _ImageInput();
  }
}

class _ImageInput extends State<ImageInput> {
  File? _selectedFile;
  void _takePicture() async {
    final imagePicker = ImagePicker();
    final file =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (file == null) {
      return;
    }

    setState(() {
      _selectedFile = File(file.path);
      widget.onSelectImage(_selectedFile!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: () {
        _takePicture();
      },
      icon: const Icon(Icons.camera),
      label: const Text('Take Picture'),
    );

    if (_selectedFile != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedFile!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: Theme.of(context).colorScheme.primary),
        ),
        height: 250,
        width: double.infinity,
        alignment: Alignment.center,
        child: content);
  }
}
