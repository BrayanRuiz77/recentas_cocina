import 'package:flutter/material.dart';
import 'package:recetas_cocina/models/recipe.dart';
import 'package:recetas_cocina/services/recipe_service.dart';
import 'package:recetas_cocina/widgets/dialogs.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final RecipeService recipeService;

  const RecipeDetailScreen({
    Key? key,
    required this.recipe,
    required this.recipeService,
  }) : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Recipe recipe;

  @override
  void initState() {
    super.initState();
    recipe = widget.recipe;
  }

  void _toggleFavorite() async {
    final updatedRecipe = recipe.copyWith(isFavorite: !recipe.isFavorite);
    await widget.recipeService.updateRecipe(updatedRecipe);
    setState(() {
      recipe = updatedRecipe;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          recipe.isFavorite
              ? 'Recipe added to favorites'
              : 'Recipe removed from favorites',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          IconButton(
            icon: Icon(
              recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe.imageUrl),
            Text(recipe.title, style: Theme.of(context).textTheme.headline5),
            const SizedBox(height: 10),
            Text(recipe.description),
            // Otros detalles de la receta...
          ],
        ),
      ),
    );
  }
}

extension on TextTheme {
  TextStyle? get headline5 => headlineMedium;
}
