import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';
import '../utils/constants.dart';

class FavoriteService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  CollectionReference _getFavoriteRef(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.favoritesSubcollection);
  }

  Future<void> addFavorite(String userId, String recipeId) async {
    await _getFavoriteRef(userId).doc(recipeId).set({
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFavorite(String userId, String recipeId) async {
    await _getFavoriteRef(userId).doc(recipeId).delete();
  }

  Stream<bool> isFavorite(String userId, String recipeId) {
    if (userId.isEmpty) return Stream.value(false);
    try {
      return _getFavoriteRef(userId)
          .doc(recipeId)
          .snapshots()
          .map((snapshot) => snapshot.exists);
    } catch (_) {
      return Stream.value(false);
    }
  }

  Stream<List<String>> getFavoriteRecipeIds(String userId) {
    if (userId.isEmpty) return Stream.value([]);
    try {
      return _getFavoriteRef(userId).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (_) {
      return Stream.value([]);
    }
  }

  // Get favorite recipe objects stream
  Stream<List<RecipeModel>> getFavoriteRecipes(String userId) {
    if (userId.isEmpty) return Stream.value([]);
    try {
      return getFavoriteRecipeIds(userId).asyncMap((ids) async {
        if (ids.isEmpty) return [];

        final List<RecipeModel> recipes = [];
        for (final id in ids) {
          final doc = await _firestore
              .collection(AppConstants.recipesCollection)
              .doc(id)
              .get();
          if (doc.exists && doc.data() != null) {
            recipes.add(RecipeModel.fromMap(doc.data()!, doc.id));
          }
        }
        return recipes;
      });
    } catch (_) {
      return Stream.value([]);
    }
  }

  Future<int> getFavoriteCount(String userId) async {
    final snapshot = await _getFavoriteRef(userId).get();
    return snapshot.docs.length;
  }
}
