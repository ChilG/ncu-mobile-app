import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_view_demo/constants/app_strings.dart';
import 'package:list_view_demo/main.dart';

void main() {
  testWidgets('Product list smoke test', (WidgetTester tester) async {
    const mockJson = '''
    [
      {
        "id": "PROD-001",
        "name": "Wireless Headphones",
        "price": 1890.00,
        "imageUrl": "assets/images/prod_001.jpg",
        "rating": 4
      },
      {
        "id": "PROD-002",
        "name": "Smart Watch Series X",
        "price": 4500.00,
        "imageUrl": "assets/images/prod_002.jpg",
        "rating": 3
      }
    ]
    ''';

    final mockAssetBundle = TestAssetBundle(mockJson);

    await tester.pumpWidget(
      DefaultAssetBundle(bundle: mockAssetBundle, child: const MyApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.homeTitle), findsOneWidget);
    expect(find.text(AppStrings.exclusiveCollection), findsOneWidget);

    expect(find.text('Wireless Headphones'), findsOneWidget);
    expect(find.text('Smart Watch Series X'), findsOneWidget);
  });
}

class TestAssetBundle extends CachingAssetBundle {
  final String jsonContent;
  TestAssetBundle(this.jsonContent);

  @override
  Future<ByteData> load(String key) async {
    if (key == 'assets/products.json') {
      return ByteData.sublistView(utf8.encode(jsonContent));
    }
    if (key.startsWith('assets/images/')) {
      final transparentPngBytes = [
        137,
        80,
        78,
        71,
        13,
        10,
        26,
        10,
        0,
        0,
        0,
        13,
        73,
        72,
        68,
        82,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        1,
        8,
        6,
        0,
        0,
        0,
        31,
        21,
        196,
        137,
        0,
        0,
        0,
        13,
        73,
        68,
        65,
        84,
        120,
        156,
        99,
        96,
        0,
        0,
        0,
        2,
        0,
        1,
        73,
        175,
        169,
        56,
        0,
        0,
        0,
        0,
        73,
        69,
        78,
        68,
        174,
        66,
        96,
        130,
      ];
      return ByteData.sublistView(Uint8List.fromList(transparentPngBytes));
    }
    throw FlutterError('Asset key not found: $key');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key == 'assets/products.json') {
      return jsonContent;
    }
    throw FlutterError('Asset key not found: $key');
  }
}
