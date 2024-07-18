import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegan: false,
          Filter.vegetarian: false
        });

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }

  void setFilters(Map<Filter, bool> filters) {
    state = filters;
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
        (ref) => FiltersNotifier());

final filteredMeals = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((it) {
    if (activeFilters[Filter.glutenFree]! && !it.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !it.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !it.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !it.isVegan) {
      return false;
    }

    return true;
  }).toList();
});
