import 'package:flutter/material.dart';
import 'package:meals_app/models/categories.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem(
      {required this.onTapCategory, required this.category, super.key});

  final Categories category;
  final void Function() onTapCategory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      onTap: onTapCategory,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              category.color.withOpacity(.55),
              category.color.withOpacity(.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          category.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
    );
  }
}
