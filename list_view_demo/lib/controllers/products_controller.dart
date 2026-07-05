import 'package:flutter/material.dart';
import 'package:list_view_demo/models/product.dart';
import 'package:list_view_demo/repositories/product_repository.dart';

class ProductsController extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Product> _masterProducts = [];
  final List<Product> _cart = [];

  List<Product> get products => _products;
  List<Product> get recommendedProducts =>
      _products.where((p) => p.rating >= 4).toList();
  List<Product> get generalProducts =>
      _products.where((p) => p.rating < 4).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Product> get cart => _cart;

  int get totalCount => _products.length;
  double get totalValue => _products.fold<double>(0, (sum, p) => sum + p.price);

  ProductsController() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _repository.getProducts();
      if (_masterProducts.isEmpty) {
        _masterProducts = List.of(_products);
      }
      _isLoading = false;
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> updateRating(Product product, int newRating) async {
    final updatedProduct = product.copyWith(rating: newRating);
    try {
      await _repository.updateProduct(updatedProduct);
      await loadProducts();
    } catch (e) {
      debugPrint('Error updating rating: $e');
      rethrow;
    }
  }

  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }

  void resetCatalog() {
    _repository.cacheList.clear();
    _cart.clear();
    loadProducts();
  }
}
