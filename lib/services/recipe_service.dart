import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';
import '../utils/constants.dart';

class RecipeService {
  final FirebaseFirestore _firestore;

  // Agregamos inyección de dependencias
  RecipeService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Agregamos manejo de errores más robusto
  Future<List<Recipe>> getRecipes() async {
    try {
      final snapshot = await _firestore
          .collection(Constants.recipeCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Recipe.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      // Lanzamos una excepción personalizada
      throw RecipeException('Error getting recipes: $e');
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _firestore
          .collection(Constants.recipeCollection)
          .add(recipe.toJson());
    } catch (e) {
      throw RecipeException('Error adding recipe: $e');
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    try {
      await _firestore
          .collection(Constants.recipeCollection)
          .doc(recipe.id)
          .update(recipe.toJson());
    } catch (e) {
      throw RecipeException('Error updating recipe: $e');
    }
  }
}

// Excepción personalizada
class RecipeException implements Exception {
  final String message;
  RecipeException(this.message);

  @override
  String toString() => message;
}
