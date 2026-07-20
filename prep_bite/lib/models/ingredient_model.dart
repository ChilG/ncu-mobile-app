class IngredientModel {
  final String name;
  final String amount;
  final String preparation;
  final bool isChecked;

  IngredientModel({
    required this.name,
    required this.amount,
    this.preparation = '',
    this.isChecked = false,
  });

  factory IngredientModel.fromMap(Map<String, dynamic> map) {
    return IngredientModel(
      name: map['name'] ?? '',
      amount: map['amount'] ?? '',
      preparation: map['preparation'] ?? '',
      isChecked: map['isChecked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'preparation': preparation,
      'isChecked': isChecked,
    };
  }

  IngredientModel copyWith({
    String? name,
    String? amount,
    String? preparation,
    bool? isChecked,
  }) {
    return IngredientModel(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      preparation: preparation ?? this.preparation,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
