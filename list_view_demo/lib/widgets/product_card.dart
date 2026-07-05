import 'package:flutter/material.dart';
import 'package:list_view_demo/models/product.dart';
import 'package:list_view_demo/utils/currency_formatter.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ValueChanged<int>? onRatingChanged;
  final VoidCallback? onAddToCart;
  final double? width;
  final EdgeInsetsGeometry? margin;

  const ProductCard({
    super.key,
    required this.product,
    this.onRatingChanged,
    this.onAddToCart,
    this.width,
    this.margin,
  });

  void _handleRatingTap(int ratingValue) {
    if (onRatingChanged != null) {
      onRatingChanged!(ratingValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.asset(
                    product.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.price.toThaiBaht(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          final ratingValue = index + 1;
                          return GestureDetector(
                            onTap: () => _handleRatingTap(ratingValue),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 1.0,
                              ),
                              child: Icon(
                                index < product.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: index < product.rating
                                    ? Colors.amber
                                    : Colors.grey.shade300,
                                size: 18,
                              ),
                            ),
                          );
                        }),
                      ),
                      if (onAddToCart != null)
                        GestureDetector(
                          onTap: onAddToCart,
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (margin != null) {
      cardContent = Padding(padding: margin!, child: cardContent);
    }

    if (width != null) {
      return SizedBox(width: width, child: cardContent);
    }

    return cardContent;
  }
}
