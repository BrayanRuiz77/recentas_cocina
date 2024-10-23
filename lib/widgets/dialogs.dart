import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../models/shopping_item.dart';
import '../models/meal_plan.dart';

class AddRecipeDialog extends StatefulWidget {
  final Function(Recipe) onSave;

  const AddRecipeDialog({Key? key, required this.onSave}) : super(key: key);

  @override
  State<AddRecipeDialog> createState() => _AddRecipeDialogState();
}

class _AddRecipeDialogState extends State<AddRecipeDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<String> _ingredients = [];
  final List<String> _instructions = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Recipe'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final recipe = Recipe(
              id: DateTime.now().toString(), // Temporal ID
              title: _titleController.text,
              description: _descriptionController.text,
              ingredients: _ingredients,
              instructions: _instructions,
              imageUrl: 'https://placeholder.com/300x200', // URL temporal
              userId: 'user123', // ID temporal
              createdAt: DateTime.now(),
            );
            widget.onSave(recipe);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class AddShoppingItemDialog extends StatefulWidget {
  final Function(ShoppingItem) onSave;

  const AddShoppingItemDialog({Key? key, required this.onSave})
      : super(key: key);

  @override
  State<AddShoppingItemDialog> createState() => _AddShoppingItemDialogState();
}

class _AddShoppingItemDialogState extends State<AddShoppingItemDialog> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Shopping Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Item Name'),
          ),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final item = ShoppingItem(
              id: DateTime.now().toString(),
              name: _nameController.text,
              quantity: _quantityController.text,
            );
            widget.onSave(item);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class AddMealPlanDialog extends StatefulWidget {
  final Function(MealPlan) onSave;

  const AddMealPlanDialog({Key? key, required this.onSave}) : super(key: key);

  @override
  State<AddMealPlanDialog> createState() => _AddMealPlanDialogState();
}

class _AddMealPlanDialogState extends State<AddMealPlanDialog> {
  DateTime selectedDate = DateTime.now();
  String selectedRecipeId = '';
  String selectedRecipeName = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Meal Plan'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              'Date: ${selectedDate.toString().split(' ')[0]}',
            ),
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
          // Aquí deberías agregar un selector de recetas
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final mealPlan = MealPlan(
              id: DateTime.now().toString(),
              date: selectedDate,
              recipeId: selectedRecipeId,
              recipeName: selectedRecipeName,
              recipeImage: 'https://placeholder.com/300x200',
            );
            widget.onSave(mealPlan);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
