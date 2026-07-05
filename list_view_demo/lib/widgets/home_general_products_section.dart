import 'package:flutter/material.dart';
import 'package:list_view_demo/constants/app_strings.dart';
import 'package:list_view_demo/models/product.dart';
import 'package:list_view_demo/widgets/product_card.dart';
import 'package:list_view_demo/widgets/home_recommended_section.dart';

class HomeGeneralProductsSection extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<ProductRatingUpdate> onRatingChanged;
  final ValueChanged<Product> onAddToCart;

  const HomeGeneralProductsSection({
    super.key,
    required this.products,
    required this.onRatingChanged,
    required this.onAddToCart,
  });

  void _handleRatingUpdate(Product product, int newRating) {
    onRatingChanged(ProductRatingUpdate(product, newRating));
  }

  void _handleAddToCart(Product product) {
    onAddToCart(product);
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            AppStrings.generalProducts,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                margin: const EdgeInsets.all(8.0),
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
