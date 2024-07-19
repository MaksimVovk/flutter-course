import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoping_app/data/categories.dart';
import 'package:shoping_app/models/grocery_item.dart';
import 'package:shoping_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var isLoading = true;
  String? _error = null;

  @override
  void initState() {
    super.initState();

    _loadItems();
  }

  void _loadItems() async {
    try {
      final url = Uri.https('flutter-prep-c32d7-default-rtdb.firebaseio.com',
          'shoping-list.json');
      final list = await http.get(url);
      if (list.statusCode >= 400) {
        return;
      }
      final Map<String, dynamic> listData = json.decode(list.body);
      List<GroceryItem> loadedItemList = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere((f) => f.value.name == item.value['category'])
            .value;
        loadedItemList.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }

      setState(() {
        _groceryItems = loadedItemList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch data. Please try again later!';
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _error = null;
      _groceryItems.add(newItem);
    });
  }

  void _removeGrocery(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    try {
      final url = Uri.https('flutter-prep-c32d7-default-rtdb.firebaseio.com',
          'shoping-list/${item.id}.json');
      await http.delete(url);
    } catch (e) {
      setState(() {
        _groceryItems.insert(index, item);
      });
      if (context.mounted) {
        // showDialog(
        //   context: context,
        //   builder: (ctx) => AlertDialog(
        //     title: const Text('Something went wrong!'),
        //     content: Text(e.toString()),
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //         child: const Text('Close'),
        //       )
        //     ],
        //   ),
        // );
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            showCloseIcon: true,
            closeIconColor: Colors.red,
            duration: Duration(seconds: 3),
            content: Text('Something went wrong while deleting!'),
          ),
        );
      }

      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isListEmpty = _groceryItems.isEmpty;
    Widget loadingWidget = const Center(child: CircularProgressIndicator());
    Widget emptyScreen = const Center(
      child: Text('No grocery found. Start adding some!'),
    );

    Widget list = ListView.builder(
      itemCount: _groceryItems.length,
      itemBuilder: (ctx, index) {
        return Dismissible(
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(.75),
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
            ),
            key: ValueKey(_groceryItems[index].id),
            onDismissed: (direction) => {_removeGrocery(_groceryItems[index])},
            child: ListTile(
              title: Text(_groceryItems[index].name),
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color,
              ),
              trailing: Text(
                _groceryItems[index].quantity.toString(),
              ),
            ));
      },
    );
    Widget listViewContent = isListEmpty ? emptyScreen : list;
    Widget content = isLoading ? loadingWidget : listViewContent;
    final isError = _error != null;

    Widget errorContent = Center(
      child: isError ? Text(_error!) : const Text('Something went wrong!'),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isError ? errorContent : content,
    );
  }
}
