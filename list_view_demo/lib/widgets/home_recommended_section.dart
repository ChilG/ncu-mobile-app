import 'package:flutter/material.dart';
import 'package:list_view_demo/constants/app_strings.dart';
import 'package:list_view_demo/models/product.dart';
import 'package:list_view_demo/widgets/product_card.dart';

class HomeRecommendedSection extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<ProductRatingUpdate> onRatingChanged;
  final ValueChanged<Product> onAddToCart;
  final VoidCallback onResetCatalog;

  const HomeRecommendedSection({
    super.key,
    required this.products,
    required this.onRatingChanged,
    required this.onAddToCart,
    required this.onResetCatalog,
  });

  void _handleRatingUpdate(Product product, int newRating) {
    onRatingChanged(ProductRatingUpdate(product, newRating));
  }

  void _handleAddToCart(Product product) {
    onAddToCart(product);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            AppStrings.recommendedForYou,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        AppStrings.emptyStore,
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: onResetCatalog,
                        child: const Text(AppStrings.resetCatalog),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      width: 220,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      onRatingChanged: (newRating) =>
                          _handleRatingUpdate(product, newRating),
                      onAddToCart: () => _handleAddToCart(product),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class ProductRatingUpdate {
  final Product product;
  final int newRating;
  ProductRatingUpdate(this.product, this.newRating);
}
