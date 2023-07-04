import 'dart:ui';

class Package {
  final String name;
  final String price;
  final String description;
  final Color? backgroundColor;

  Package({
    required this.name,
    required this.price,
    required this.description,
    this.backgroundColor,
  });
}
