import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ingredient_model.dart';
import '../utils/constants.dart';

class ChecklistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference _getChecklistDoc(String userId, String recipeId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.checklistsSubcollection)
        .doc(recipeId);
  }

  Future<void> saveChecklist(
    String userId,
    String recipeId,
    List<IngredientModel> ingredients,
  ) async {
    await _getChecklistDoc(userId, recipeId).set({
      'updatedAt': FieldValue.serverTimestamp(),
      'ingredients': ingredients.map((e) => e.toMap()).toList(),
    });
  }

  Stream<List<IngredientModel>?> getChecklistStream(
    String userId,
    String recipeId,
  ) {
    return _getChecklistDoc(userId, recipeId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      final data = snapshot.data() as Map<String, dynamic>;
      final list = (data['ingredients'] as List<dynamic>?)
          ?.map((e) => IngredientModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      return list;
    });
  }

  Future<void> resetChecklist(
    String userId,
    String recipeId,
    List<IngredientModel> defaultIngredients,
  ) async {
    final resetList = defaultIngredients
        .map((e) => e.copyWith(isChecked: false))
        .toList();
    await saveChecklist(userId, recipeId, resetList);
  }

  Future<void> updateIngredientStatus(
    String userId,
    String recipeId,
    List<IngredientModel> updatedIngredients,
  ) async {
    await saveChecklist(userId, recipeId, updatedIngredients);
  }
}
