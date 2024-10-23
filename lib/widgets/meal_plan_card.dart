import 'package:flutter/material.dart';
import '../models/meal_plan.dart';
import '../theme/app_colors.dart';
import '../utils/helpers.dart';

class MealPlanCard extends StatelessWidget {
  final MealPlan mealPlan;
  final VoidCallback onTap;

  const MealPlanCard({
    Key? key,
    required this.mealPlan,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            mealPlan.recipeImage,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 60,
                width: 60,
                color: AppColors.lightGrey,
                child: const Icon(Icons.broken_image),
              );
            },
          ),
        ),
        title: Text(
          mealPlan.recipeName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${Helpers.formatDate(mealPlan.date)}',
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
