import 'package:expense_tracker_app/widgets/chart/chart.dart';
import 'package:expense_tracker_app/widgets/expense_list/expenses_list.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<StatefulWidget> createState() {
    return _Expenses();
  }
}

class _Expenses extends State<Expenses> {
  final List<Expense> _registeredExpense = [
    Expense(
      amount: 19.991,
      title: 'Flutter Course',
      date: DateTime.now(),
      category: Categories.work,
    ),
    Expense(
      amount: 15.699,
      title: 'Cinema',
      date: DateTime.now(),
      category: Categories.leisure,
    ),
  ];

  void _removeExpense(Expense val) {
    final expenseIndex = _registeredExpense.indexOf(val);
    setState(() {
      _registeredExpense.remove(val);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.red,
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpense.insert(expenseIndex, val);
            });
          },
        ),
      ),
    );
  }

  void save(
      {required String title,
      required double amount,
      required DateTime? date,
      required Categories category}) {
    DateTime newDate = date ?? DateTime.now();
    setState(() {
      _registeredExpense.add(Expense(
          amount: amount, title: title, date: newDate, category: category));
    });
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        save: save,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    // print(MediaQuery.of(context).size.width);
    Widget mainContent = const Center(
      child: Text('No expense found. Start adding some!'),
    );

    if (_registeredExpense.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpense,
        removeExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Flutter expense tracker',
              textAlign: TextAlign.left,
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: isLandscape
          ? Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpense)),
                Expanded(child: mainContent),
              ],
            )
          : Column(
              children: [
                Chart(expenses: _registeredExpense),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
