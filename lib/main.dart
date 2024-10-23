import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:recetas_cocina/models/recipe.dart';
import 'package:recetas_cocina/widgets/dialogs.dart';
import 'package:recetas_cocina/widgets/recipe_card.dart';
import 'models/shopping_item.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'services/recipe_service.dart';
import 'services/shopping_list_service.dart';
import 'services/meal_plan_service.dart';
import 'screens/home_screen.dart';
import 'widgets/meal_plan_card.dart';
import 'widgets/shopping_list_item.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Forzar orientación vertical (opcional)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: AppTheme.light,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RecipeService _recipeService = RecipeService();
  final ShoppingListService _shoppingListService = ShoppingListService();
  final MealPlanService _mealPlanService = MealPlanService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.restaurant_menu), text: 'Recipes'),
            Tab(icon: Icon(Icons.kitchen), text: 'Prepare'),
            Tab(icon: Icon(Icons.shopping_cart), text: 'Shopping'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Plan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RecipesTab(recipeService: _recipeService),
          const PrepareTab(),
          ShoppingListTab(shoppingListService: _shoppingListService),
          MealPlanTab(mealPlanService: _mealPlanService),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    // FAB contextual según la pestaña actual
    switch (_tabController.index) {
      case 0:
        return FloatingActionButton(
          onPressed: () => _showAddRecipeDialog(),
          child: const Icon(Icons.add),
        );
      case 2:
        return FloatingActionButton(
          onPressed: () => _showAddShoppingItemDialog(),
          child: const Icon(Icons.add),
        );
      case 3:
        return FloatingActionButton(
          onPressed: () => _showAddMealPlanDialog(),
          child: const Icon(Icons.add),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _showAddRecipeDialog() {
    // Implementar diálogo para agregar receta
    showDialog(
      context: context,
      builder: (context) => AddRecipeDialog(
        onSave: (recipe) async {
          await _recipeService.addRecipe(recipe);
          setState(() {});
        },
      ),
    );
  }

  void _showAddShoppingItemDialog() {
    // Implementar diálogo para agregar item de compra
    showDialog(
      context: context,
      builder: (context) => AddShoppingItemDialog(
        onSave: (item) async {
          await _shoppingListService.addShoppingItem(item);
          setState(() {});
        },
      ),
    );
  }

  void _showAddMealPlanDialog() {
    // Implementar diálogo para agregar plan de comida
    showDialog(
      context: context,
      builder: (context) => AddMealPlanDialog(
        onSave: (mealPlan) async {
          await _mealPlanService.addMealPlan(mealPlan);
          setState(() {});
        },
      ),
    );
  }
}

// Implementación de las pestañas
class RecipesTab extends StatelessWidget {
  final RecipeService recipeService;

  const RecipesTab({super.key, required this.recipeService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: recipeService.getRecipes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final recipes = snapshot.data ?? [];

        if (recipes.isEmpty) {
          return const Center(
            child: Text('No recipes found. Add your first recipe!'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return RecipeCard(
              recipe: recipe,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: recipe),
                ),
              ),
              onFavoritePressed: () async {
                final updatedRecipe = recipe.copyWith(
                  isFavorite: !recipe.isFavorite,
                );
                await recipeService.updateRecipe(updatedRecipe);
              },
            );
          },
        );
      },
    );
  }

  RecipeDetailScreen({required Recipe recipe}) {}
}

class PrepareTab extends StatelessWidget {
  const PrepareTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Prepare Tab - Coming Soon'),
    );
  }
}

class ShoppingListTab extends StatelessWidget {
  final ShoppingListService shoppingListService;

  const ShoppingListTab({super.key, required this.shoppingListService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: shoppingListService.getShoppingList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return const Center(
            child: Text('Your shopping list is empty!'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ShoppingListItem(
              item: item,
              onChanged: (value) async {
                final updatedItem = ShoppingItem(
                  id: item.id,
                  name: item.name,
                  quantity: item.quantity,
                  isCompleted: value ?? false,
                );
                await shoppingListService.updateShoppingItem(updatedItem);
              },
            );
          },
        );
      },
    );
  }
}

class MealPlanTab extends StatelessWidget {
  final MealPlanService mealPlanService;

  const MealPlanTab({super.key, required this.mealPlanService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mealPlanService.getMealPlans(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final mealPlans = snapshot.data ?? [];

        if (mealPlans.isEmpty) {
          return const Center(
            child: Text('No meal plans yet. Start planning your meals!'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: mealPlans.length,
          itemBuilder: (context, index) {
            final mealPlan = mealPlans[index];
            return MealPlanCard(
              mealPlan: mealPlan,
              onTap: () {
                // Implementar navegación al detalle del plan
              },
            );
          },
        );
      },
    );
  }
}
