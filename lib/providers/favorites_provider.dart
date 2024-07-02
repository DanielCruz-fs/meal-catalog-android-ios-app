import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

/// This class is a StateNotifier that manages the favorite meals.
/// It extends StateNotifier<List<Meal>> because we want to manage a list of meals.
/// The constructor initializes the state with an empty list.
/// The toggleMealFavoriteStatus method is used to toggle the favorite status of a meal.
/// If the meal is already in the list, it is removed; otherwise, it is added.
/// The favoriteMealsProvider is a StateNotifierProvider that provides an instance of FavoriteMealsNotifier.
/// This provider is used to access the favorite meals state and update it.
/// The provider is used in the app to manage the favorite meals.
///
/// why immutablity is important?
/// Immutability is important because it allows us to track changes in the state.
///
/// why return false or true in toggleMealFavoriteStatus?
/// The toggleMealFavoriteStatus method returns a boolean value to indicate whether the meal was added or removed from the list.
class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

// why statenotifierprovider? because we want to change the state of the favorite meals
// Hence, we need to use StateNotifierProvider instead of Provider
final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});
