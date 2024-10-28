import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recetas_cocina/models/recipe.dart';
import 'package:recetas_cocina/utils/constants.dart';

class RecipeService {
  final FirebaseFirestore _firestore;

  // Constructor con inyección de dependencias
  RecipeService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Obtiene todas las recetas ordenadas por fecha de creación
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
      throw RecipeException('Error getting recipes: $e');
    }
  }

  // Agrega una receta usando el ID de la receta
  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _firestore
          .collection(Constants.recipeCollection)
          .doc(recipe.id) // Usa el ID de la receta para agregarla
          .set(recipe.toJson());
    } catch (e) {
      throw RecipeException('Error adding recipe: $e');
    }
  }

  // Actualiza una receta existente
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

// Excepción personalizada para manejar errores específicos de RecipeService
class RecipeException implements Exception {
  final String message;
  RecipeException(this.message);

  @override
  String toString() => message;
}
