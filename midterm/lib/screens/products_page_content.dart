import 'package:flutter/material.dart';

class ProductsPageContent extends StatefulWidget {
  const ProductsPageContent({super.key});

  @override
  State<ProductsPageContent> createState() => _ProductsPageContentState();
}

class _ProductsPageContentState extends State<ProductsPageContent> {
  bool _isAddedToCart = false;

  void _toggleAddToCart() {
    setState(() {
      _isAddedToCart = !_isAddedToCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag, size: 100, color: Colors.green),
          const SizedBox(height: 10),
          const Text(
            'หน้าสินค้า',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _toggleAddToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isAddedToCart ? Colors.green : Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text(_isAddedToCart ? 'เพิ่มสินค้าแล้ว' : 'เพิ่มสินค้า'),
          ),
        ],
      ),
    );
  }
}
