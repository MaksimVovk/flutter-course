import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoping_app/data/categories.dart';
import 'package:shoping_app/enums/categories_enum.dart';
import 'package:http/http.dart' as http;
import 'package:shoping_app/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItem();
  }
}

class _NewItem extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false;

  String? _validateName(value) {
    final isEmpty = value == null || value.isEmpty;
    final isInvalidLenght = value.trim().length < 2 || value.length > 50;
    if (isEmpty || isInvalidLenght) {
      return 'Must be between 1 and 50 characters.';
    }

    return null;
  }

  String? _validateQuantity(value) {
    final isEmpty = value == null || value.isEmpty;
    final isInvalidValue =
        int.tryParse(value) == null || int.tryParse(value)! < 1;
    if (isEmpty || isInvalidValue) {
      return 'Must be between 1 and 50 characters.';
    }

    return null;
  }

  void _save() async {
    if (_isSending) {
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      final url = Uri.https('flutter-prep-c32d7-default-rtdb.firebaseio.com',
          'shoping-list.json');
      final res = await http.post(
        url,
        headers: {'Content-Type': 'aplication/json'},
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': _selectedCategory.name,
          },
        ),
      );

      if (!context.mounted) {
        return;
      }
      final Map<String, dynamic> response = json.decode(res.body);
      setState(() {
        _isSending = false;
      });
      Navigator.of(context).pop(GroceryItem(
        id: response['name'],
        name: _enteredName,
        quantity: _enteredQuantity,
        category: _selectedCategory,
      ));
    }
  }

  void _reset() {
    if (_isSending) {
      return;
    }

    _formKey.currentState!.reset();
  }

  Widget loadingWidget = const Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Name'),
                      ),
                      validator: _validateName,
                      onSaved: (value) {
                        _enteredName = value!;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: _enteredQuantity.toString(),
                      validator: _validateQuantity,
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      color: category.value.color),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.name)
                              ],
                            ),
                          ),
                      ],
                      onChanged: (item) {
                        if (item == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = item;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _reset,
                    child: const Text('Reset'),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: _save,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Save'),
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
