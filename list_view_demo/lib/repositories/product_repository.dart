import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:list_view_demo/models/product.dart';

class ProductRepository {
  final List<Product> _products = [];

  Future<List<Product>> getProducts() async {
    if (_products.isEmpty) {
      try {
        final jsonString = await rootBundle.loadString('assets/products.json');
        final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
        _products.addAll(
          jsonList.map(
            (item) => Product.fromJson(item as Map<String, dynamic>),
          ),
        );
      } catch (e) {
        debugPrint('Error loading initial products from JSON asset: $e');
        throw Exception('Failed to load products from JSON asset: $e');
      }
    }
    return List.of(_products);
  }

  Future<Product?> getProduct(String id) async {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addProduct(Product product) async {
    if (_products.any((p) => p.id == product.id)) {
      throw Exception('Product with ID ${product.id} already exists.');
    }
    _products.add(product);
  }

  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    } else {
      throw Exception('Product with ID ${product.id} not found.');
    }
  }

  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }

  List<Product> get cacheList => _products;
}
