import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';
import '../utils/constants.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      print('Error getting recipes: $e');
      return [];
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _firestore
          .collection(Constants.recipeCollection)
          .add(recipe.toJson());
    } catch (e) {
      print('Error adding recipe: $e');
      throw e;
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    try {
      await _firestore
          .collection(Constants.recipeCollection)
          .doc(recipe.id)
          .update(recipe.toJson());
    } catch (e) {
      print('Error updating recipe: $e');
      throw e;
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _firestore
          .collection(Constants.recipeCollection)
          .doc(recipeId)
          .delete();
    } catch (e) {
      print('Error deleting recipe: $e');
      throw e;
    }
  }
}
