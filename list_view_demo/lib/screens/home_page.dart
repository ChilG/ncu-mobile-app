import 'package:flutter/material.dart';
import 'package:list_view_demo/constants/app_strings.dart';
import 'package:list_view_demo/controllers/products_controller.dart';
import 'package:list_view_demo/models/product.dart';
import 'package:list_view_demo/screens/cart_screen.dart';
import 'package:list_view_demo/widgets/home_hero_section.dart';
import 'package:list_view_demo/widgets/home_recommended_section.dart';
import 'package:list_view_demo/widgets/home_general_products_section.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final ProductsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProductsController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onRatingChanged(ProductRatingUpdate update) async {
    try {
      await _controller.updateRating(update.product, update.newRating);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.ratingUpdated(update.product.name, update.newRating),
          ),
          duration: const Duration(milliseconds: 800),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.ratingUpdateError} $e')),
      );
    }
  }

  void _onAddToCart(Product product) {
    _controller.addToCart(product);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.addedProductToCart(product.name)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onCartPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(controller: _controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final isLoading = _controller.isLoading;
        final errorMessage = _controller.errorMessage;
        final totalProductCount = _controller.totalCount;
        final totalStoreValue = _controller.totalValue;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            title: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            elevation: 0,
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Badge(
                  isLabelVisible: _controller.cart.isNotEmpty,
                  label: Text('${_controller.cart.length}'),
                  child: IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    onPressed: _onCartPressed,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: AppStrings.reloadFromBackup,
                onPressed: _controller.resetCatalog,
              ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeroSection(
                        totalProductCount: totalProductCount,
                        totalStoreValue: totalStoreValue,
                      ),
                      const SizedBox(height: 24),
                      HomeRecommendedSection(
                        products: _controller.recommendedProducts,
                        onRatingChanged: _onRatingChanged,
                        onAddToCart: _onAddToCart,
                        onResetCatalog: _controller.resetCatalog,
                      ),
                      const SizedBox(height: 24),
                      HomeGeneralProductsSection(
                        products: _controller.generalProducts,
                        onRatingChanged: _onRatingChanged,
                        onAddToCart: _onAddToCart,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
