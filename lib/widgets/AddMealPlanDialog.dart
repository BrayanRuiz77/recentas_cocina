import 'package:flutter/material.dart';
import 'package:recetas_cocina/models/meal_plan.dart';
import 'package:recetas_cocina/models/recipe.dart';

class AddMealPlanDialog extends StatefulWidget {
  final Function(MealPlan) onSave;
  final List<Recipe> recipes; // Recetas disponibles

  const AddMealPlanDialog({
    Key? key,
    required this.onSave,
    required this.recipes,
  }) : super(key: key);

  @override
  State<AddMealPlanDialog> createState() => _AddMealPlanDialogState();
}

class _AddMealPlanDialogState extends State<AddMealPlanDialog> {
  DateTime selectedDate = DateTime.now();
  Recipe? selectedRecipe; // Objeto de receta seleccionado

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Meal Plan'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Date: ${selectedDate.toString().split(' ')[0]}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
          ),
          DropdownButton<Recipe>(
            value: selectedRecipe,
            hint: const Text('Select a recipe'),
            items: widget.recipes.map((recipe) {
              return DropdownMenuItem<Recipe>(
                value: recipe,
                child: Text(recipe.title),
              );
            }).toList(),
            onChanged: (Recipe? newRecipe) {
              setState(() {
                selectedRecipe = newRecipe;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: selectedRecipe != null
              ? () {
                  final mealPlan = MealPlan(
                    id: DateTime.now().toString(),
                    date: selectedDate,
                    recipeId: selectedRecipe!.id,
                    recipeName: selectedRecipe!.title,
                    recipeImage: selectedRecipe!.imageUrl,
                  );
                  widget.onSave(mealPlan);
                  Navigator.pop(context);
                }
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
