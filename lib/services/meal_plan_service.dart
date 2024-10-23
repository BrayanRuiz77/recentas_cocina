}import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal_plan.dart';
import '../utils/constants.dart';

class MealPlanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MealPlan>> getMealPlans() async {
    try {
      final snapshot = await _firestore
          .collection(Constants.mealPlanCollection)
          .orderBy('date')
          .get();

      return snapshot.docs
          .map((doc) => MealPlan.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting meal plans: $e');
      return [];
    }
  }

  Future<void> addMealPlan(MealPlan mealPlan) async {
    try {
      await _firestore
          .collection(Constants.mealPlanCollection)
          .add(mealPlan.toJson());
    } catch (e) {
      print('Error adding meal plan: $e');
      throw e;
    }
  }
}