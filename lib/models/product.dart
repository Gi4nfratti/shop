import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../auth/keysSecret.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    try {
      _toggleFavorite();

      final response = await http.put(
          Uri.parse(
            '${USER_FAVORITES_URL}/$userId/$id.json?auth=$token',
          ),
          body: jsonEncode({
            "isFavorite": isFavorite,
          }));

      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (_) {
      _toggleFavorite();
    }
  }
}
