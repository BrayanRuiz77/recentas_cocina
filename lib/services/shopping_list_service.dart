import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shopping_item.dart';
import '../utils/constants.dart';

class ShoppingListService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ShoppingItem>> getShoppingList() async {
    try {
      final snapshot = await _firestore
          .collection(Constants.shoppingListCollection)
          .orderBy('isCompleted')
          .get();

      return snapshot.docs
          .map((doc) => ShoppingItem.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting shopping list: $e');
      return [];
    }
  }

  Future<void> addShoppingItem(ShoppingItem item) async {
    try {
      await _firestore
          .collection(Constants.shoppingListCollection)
          .add(item.toJson());
    } catch (e) {
      print('Error adding shopping item: $e');
      throw e;
    }
  }

  Future<void> updateShoppingItem(ShoppingItem item) async {
    try {
      await _firestore
          .collection(Constants.shoppingListCollection)
          .doc(item.id)
          .update(item.toJson());
    } catch (e) {
      print('Error updating shopping item: $e');
      throw e;
    }
  }
}
