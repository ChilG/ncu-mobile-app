import 'package:flutter/material.dart';
import 'package:list_view_demo/constants/app_strings.dart';
import 'package:list_view_demo/controllers/products_controller.dart';
import 'package:list_view_demo/models/product.dart';
import 'package:list_view_demo/widgets/cart_empty_state.dart';
import 'package:list_view_demo/widgets/cart_list_view.dart';
import 'package:list_view_demo/widgets/cart_summary_panel.dart';

class CartScreen extends StatelessWidget {
  final ProductsController controller;

  const CartScreen({super.key, required this.controller});

  void _onRemoveItem(BuildContext context, Product product) {
    controller.removeFromCart(product);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.removedProductFromCart(product.name)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onCheckout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.checkoutProcessing),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final cartItems = controller.cart;
        final totalCartValue = cartItems.fold<double>(
          0,
          (sum, p) => sum + p.price,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              AppStrings.cartTitle,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          body: cartItems.isEmpty
              ? const CartEmptyState()
              : Column(
                  children: [
                    Expanded(
                      child: CartListView(
                        cartItems: cartItems,
                        onRemoveItem: (product) =>
                            _onRemoveItem(context, product),
                      ),
                    ),
                    CartSummaryPanel(
                      totalCartValue: totalCartValue,
                      onCheckout: () => _onCheckout(context),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
