import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_intput.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

class AddDetailScreen extends ConsumerStatefulWidget {
  const AddDetailScreen({super.key});

  @override
  ConsumerState<AddDetailScreen> createState() {
    return _AddDetailScreenState();
  }
}

class _AddDetailScreenState extends ConsumerState<AddDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredTitle = '';
  File? _selectedFile;
  PlaceLocation? _selectedLocation;

  String? _validateTitle(value) {
    final isEmpty = value == null ||
        value.isEmpty ||
        value.trim().length < 2 ||
        value.length > 50;
    if (isEmpty) {
      return 'Must be between 1 and 50 characters.';
    }
    return null;
  }

  void _saveTitle(value) {
    _enteredTitle = value;
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_enteredTitle.isEmpty ||
          _selectedFile == null ||
          _selectedLocation == null) {
        return;
      }

      final appDir = await syspath.getApplicationDocumentsDirectory();
      final filename = path.basename(_selectedFile!.path);
      final copiedImage = await _selectedFile!.copy('${appDir.path}/$filename');
      final place = Place(
        title: _enteredTitle,
        image: copiedImage,
        location: _selectedLocation!,
      );
      ref.read(placesProvider.notifier).addPlace(place);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                style: const TextStyle(color: Colors.white),
                maxLength: 50,
                initialValue: _enteredTitle,
                validator: _validateTitle,
                onSaved: _saveTitle,
              ),
              const SizedBox(height: 12),
              ImageInput(
                onSelectImage: (image) {
                  _selectedFile = image;
                },
              ),
              const SizedBox(height: 16),
              LocationInput(
                onSelectedLocation: (location) {
                  _selectedLocation = location;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Add Place',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      _save();
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
