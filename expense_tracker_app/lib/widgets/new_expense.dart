import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker_app/models/expense.dart';

final formated = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.save});
  final void Function(
      {required String title,
      required double amount,
      required DateTime? date,
      required Categories category}) save;
  @override
  State<StatefulWidget> createState() {
    return _NewExpense();
  }
}

class _NewExpense extends State<NewExpense> {
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  DateTime? _selectedDate;
  Categories _selectedCategory = Categories.leisure;

  void _presenDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _handleCategory(Categories category) => setState(
        () {
          _selectedCategory = category;
        },
      );
  void _handleErrorMessage({required String error, required String title}) {
    final isAndroid = Platform.isAndroid;
    final dialog = isAndroid ? showDialog : showCupertinoDialog;
    dialog(
      context: context,
      builder: (ctx) => isAndroid
          ? AlertDialog(
              title: Text(title),
              content: Text(error),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                )
              ],
            )
          : CupertinoAlertDialog(
              title: Text(title),
              content: Text(error),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                )
              ],
            ),
    );
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountCtrl.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    final titleIsInvalid = _titleCtrl.text.trim().isEmpty;
    final dateIsInvalid = _selectedDate == null;
    if (titleIsInvalid) {
      _handleErrorMessage(
          title: 'Invalid title input',
          error: 'Please make shure a valid title was entered!');
      return;
    }

    if (amountIsInvalid) {
      _handleErrorMessage(
          title: 'Invalid amount input',
          error: 'Please make shure a valid amount was entered!');
      return;
    }

    if (dateIsInvalid) {
      _handleErrorMessage(
          title: 'Invalid date input',
          error: 'Please make shure a valid date was entered!');
      return;
    }

    widget.save(
      title: _titleCtrl.text,
      amount: double.parse(_amountCtrl.text),
      date: _selectedDate,
      category: _selectedCategory,
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraint) {
      final width = constraint.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyBoardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleCtrl,
                            maxLength: 50,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: TextField(
                            controller: _amountCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleCtrl,
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Categories.values
                              .map(
                                (it) => DropdownMenuItem(
                                  value: it,
                                  child: Text(
                                    it.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val == null) {
                              return;
                            }

                            _handleCategory(val);
                          },
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'No date selected'
                                    : formated.format(_selectedDate!),
                              ),
                              IconButton(
                                onPressed: _presenDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'No date selected'
                                    : formated.format(_selectedDate!),
                              ),
                              IconButton(
                                onPressed: _presenDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text('Save'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Categories.values
                              .map(
                                (it) => DropdownMenuItem(
                                  value: it,
                                  child: Text(
                                    it.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val == null) {
                              return;
                            }

                            _handleCategory(val);
                          },
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text('Save'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ],
                    )
                ],
              )),
        ),
      );
    });
  }
}
