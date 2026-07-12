import 'dart:math' as math;

class AreaCalculator {
  static double calculateRectangle(double width, double height) {
    if (width < 0 || height < 0) {
      throw ArgumentError('Width and height must be non-negative');
    }
    return width * height;
  }

  static double calculateTriangle(double base, double height) {
    if (base < 0 || height < 0) {
      throw ArgumentError('Base and height must be non-negative');
    }
    return 0.5 * base * height;
  }

  static double calculateCircle(double radius) {
    if (radius < 0) {
      throw ArgumentError('Radius must be non-negative');
    }
    return math.pi * radius * radius;
  }
}
