import 'package:flutter/material.dart';
import 'package:recetas_cocina/models/recipe.dart';
import 'package:recetas_cocina/services/recipe_service.dart';
import 'package:recetas_cocina/widgets/recipe_card.dart';
import 'package:recetas_cocina/widgets/custom_tab_bar.dart';
import 'package:recetas_cocina/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RecipeService _recipeService = RecipeService();
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchRecipes(); // Carga las recetas al iniciar
  }

  Future<void> _fetchRecipes() async {
    _recipes = await _recipeService.getRecipes();
    setState(() {}); // Actualiza la UI
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe App'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout), // Icono de cerrar sesión
            onPressed: () async {
              final authService = AuthService();
              await authService.signOut(context);
            },
          ),
        ],
        bottom: CustomTabBar(controller: _tabController),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RecipesTab(recipes: _recipes), // Lista de recetas
          PrepareTab(), // Pantalla de preparación
          ShoppingTab(), // Lista de compras
          MealPlanTab(), // Plan de comidas
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (context.mounted) {
            Navigator.pushNamed(context, '/add_recipe');
          }
        },
        child: const Icon(Icons.add), // Icono de agregar
      ),
    );
  }
}

// Widgets para cada pestaña

class RecipesTab extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipesTab({required this.recipes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeCard(
          recipe: recipes[index],
          onTap: () {
            Navigator.pushNamed(context, '/recipe_details',
                arguments: recipes[index]);
          },
        );
      },
    );
  }
}

class PrepareTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Prepare Tab'),
    );
  }
}

class ShoppingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Shopping Tab'),
    );
  }
}

class MealPlanTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Meal Plan Tab'),
    );
  }
}
