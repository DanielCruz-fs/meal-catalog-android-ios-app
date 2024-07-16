import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_grid_item.dart';

// we convert this widget to a stateful widget because we want to animate it explicitly
// 'cause we need the state to animate the widget
class CategoriesScreen extends StatefulWidget {
  final List<Meal> availableMeals;

  const CategoriesScreen({super.key, required this.availableMeals});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

// with: is used to mix in a class to the current class, singletickerproviderstatemixin is a class that provides a ticker
// for single if we have multiple tickers we use tickerproviderstatemixin
class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  // we use 'late' 'cause we're sure that this controller will be initialized before we use it
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // vsync is responsible for the lifecycle of the animation (60 times per second, 120 times per second, etc.)
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        lowerBound: 0,
        upperBound: 1);

    // we must call forward to start the animation
    _animationController.forward();
  }

  // animation controller should be disposed to avoid memory leaks
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  //* THIS IS A CLOSURE
  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  // we use AnimatedBuilder to animate the widget
  // we use the animation controller to animate the widget
  // we use the child property to animate the child widget (GridView) for performance reasons (we don't want to animate the entire widget only its padding)
  // we use the builder property to animate the widget itself, the anonymous function takes the context and the child widget and it is executeed every time the animation controller changes
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          //* alternative: availablecategories.map(...)
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            )
        ],
      ),
      builder: (context, child) => Padding(
        padding: EdgeInsets.only(top: 100 - _animationController.value * 100),
        child: child,
      ),
      // builder: (context, child) => SlideTransition(
      //   position: Tween(
      //     begin: const Offset(0, 0.3),
      //     end: const Offset(0, 0),
      //   ).animate(
      //     CurvedAnimation(
      //       parent: _animationController,
      //       curve: Curves.easeInOut,
      //     ),
      //   ),
      //   child: child,
      // ),
    );
  }
}

// note: Animating just the padding is a good practice for performance reasons
// which is less comutationally intensive and provides smooth animations