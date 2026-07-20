import 'package:cloud_firestore/cloud_firestore.dart';
import 'ingredient_model.dart';

class RecipeModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final int prepTime; // in minutes
  final int cookingTime; // in minutes
  final int servings;
  final String difficulty;
  final bool isRecommended;
  final List<IngredientModel> ingredients;
  final List<String> steps;
  final String createdBy;
  final DateTime? createdAt;

  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.prepTime,
    required this.cookingTime,
    required this.servings,
    required this.difficulty,
    this.isRecommended = false,
    required this.ingredients,
    required this.steps,
    required this.createdBy,
    this.createdAt,
  });

  factory RecipeModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime? parsedDate;
    if (map['createdAt'] != null) {
      if (map['createdAt'] is Timestamp) {
        parsedDate = (map['createdAt'] as Timestamp).toDate();
      } else if (map['createdAt'] is String) {
        parsedDate = DateTime.tryParse(map['createdAt']);
      }
    }

    return RecipeModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? 'อาหารจานเดียว',
      prepTime: (map['prepTime'] as num?)?.toInt() ?? 0,
      cookingTime: (map['cookingTime'] as num?)?.toInt() ?? 0,
      servings: (map['servings'] as num?)?.toInt() ?? 1,
      difficulty: map['difficulty'] ?? 'ง่าย',
      isRecommended: map['isRecommended'] ?? false,
      ingredients: (map['ingredients'] as List<dynamic>?)
              ?.map((e) => IngredientModel.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      steps: (map['steps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdBy: map['createdBy'] ?? '',
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'prepTime': prepTime,
      'cookingTime': cookingTime,
      'servings': servings,
      'difficulty': difficulty,
      'isRecommended': isRecommended,
      'ingredients': ingredients.map((e) => e.toMap()).toList(),
      'steps': steps,
      'createdBy': createdBy,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  RecipeModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
    int? prepTime,
    int? cookingTime,
    int? servings,
    String? difficulty,
    bool? isRecommended,
    List<IngredientModel>? ingredients,
    List<String>? steps,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      prepTime: prepTime ?? this.prepTime,
      cookingTime: cookingTime ?? this.cookingTime,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      isRecommended: isRecommended ?? this.isRecommended,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
