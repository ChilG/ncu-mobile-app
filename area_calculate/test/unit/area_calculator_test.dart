import 'package:flutter_test/flutter_test.dart';
import 'package:area_calculate/utils/area_calculator.dart';
import 'dart:math' as math;

void main() {
  group('AreaCalculator - Rectangle', () {
    test('Calculates area for positive integers', () {
      expect(AreaCalculator.calculateRectangle(5, 10), 50.0);
    });

    test('Calculates area for decimals', () {
      expect(AreaCalculator.calculateRectangle(2.5, 4.0), 10.0);
    });

    test('Returns 0 if width is 0', () {
      expect(AreaCalculator.calculateRectangle(0, 10), 0.0);
    });

    test('Returns 0 if height is 0', () {
      expect(AreaCalculator.calculateRectangle(5, 0), 0.0);
    });

    test('Throws ArgumentError for negative width', () {
      expect(
        () => AreaCalculator.calculateRectangle(-5, 10),
        throwsArgumentError,
      );
    });

    test('Throws ArgumentError for negative height', () {
      expect(
        () => AreaCalculator.calculateRectangle(5, -10),
        throwsArgumentError,
      );
    });
  });

  group('AreaCalculator - Triangle', () {
    test('Calculates area for positive integers', () {
      expect(AreaCalculator.calculateTriangle(6, 8), 24.0);
    });

    test('Calculates area for decimals', () {
      expect(AreaCalculator.calculateTriangle(5, 5), 12.5);
    });

    test('Returns 0 if base is 0', () {
      expect(AreaCalculator.calculateTriangle(0, 10), 0.0);
    });

    test('Returns 0 if height is 0', () {
      expect(AreaCalculator.calculateTriangle(5, 0), 0.0);
    });

    test('Throws ArgumentError for negative base', () {
      expect(
        () => AreaCalculator.calculateTriangle(-6, 8),
        throwsArgumentError,
      );
    });

    test('Throws ArgumentError for negative height', () {
      expect(
        () => AreaCalculator.calculateTriangle(6, -8),
        throwsArgumentError,
      );
    });
  });

  group('AreaCalculator - Circle', () {
    test('Calculates area for positive radius', () {
      expect(AreaCalculator.calculateCircle(7), closeTo(math.pi * 49, 0.0001));
    });

    test('Returns 0 if radius is 0', () {
      expect(AreaCalculator.calculateCircle(0), 0.0);
    });

    test('Throws ArgumentError for negative radius', () {
      expect(() => AreaCalculator.calculateCircle(-7), throwsArgumentError);
    });
  });
}
