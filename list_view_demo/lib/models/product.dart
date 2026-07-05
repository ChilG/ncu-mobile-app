class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final int rating;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      rating: json['rating'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    int? rating,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
    );
  }
}
