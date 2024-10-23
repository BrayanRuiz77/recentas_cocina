import 'package:flutter/material.dart';
import 'package:recetas_cocina/models/recipe.dart';
import 'package:recetas_cocina/services/recipe_service.dart';
import 'package:recetas_cocina/widgets/recipe_card.dart';
import 'package:recetas_cocina/widgets/custom_tab_bar.dart'; // Para la barra de pestañas personalizada

class HomeScreen extends StatefulWidget {
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
        title: Text('Recipe App'), // Cambia el título
        bottom: CustomTabBar(
            controller: _tabController), // La barra de pestañas personalizada
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pestaña de recetas
          RecipesTab(recipes: _recipes), // Muestra la lista de recetas

          // Pestaña de preparación (Prepare)
          PrepareTab(), //  Pantalla para mostrar la preparación de una receta

          // Pestaña de la lista de compras (Shopping)
          ShoppingTab(), //  Pantalla para gestionar la lista de compras

          // Pestaña del plan de comidas (Plan)
          MealPlanTab(), //  Pantalla para gestionar el plan de comidas
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //  Acción para agregar una nueva receta
          Navigator.pushNamed(context,
              '/add_recipe'); // Puedes usar una ruta para agregar una receta
        },
        child: Icon(Icons.add), // Icono de agregar
      ),
    );
  }
}

// Widgets para cada pestaña

class RecipesTab extends StatelessWidget {
  final List<Recipe> recipes;

  RecipesTab({required this.recipes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeCard(
          recipe: recipes[index],
          onTap: () {
            // Acción para mostrar los detalles de la receta
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
    return Center(
      child: Text(
          'Prepare Tab'), //  Aquí puedes mostrar la preparación de una receta
    );
  }
}

class ShoppingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Shopping Tab'), //  Aquí puedes mostrar la lista de compras
    );
  }
}

class MealPlanTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Meal Plan Tab'), //  Aquí puedes mostrar el plan de comidas
    );
  }
}
