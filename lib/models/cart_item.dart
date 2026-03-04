import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final String image;
  final int price;
  final String size;
  final Color color;
  final String colorName;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.size,
    required this.color,
    required this.colorName,
    required this.quantity,
  });

  int get totalPrice => price * quantity;
}
