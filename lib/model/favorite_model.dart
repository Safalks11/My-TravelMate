import 'package:flutter/material.dart';

class FavoriteModel extends ChangeNotifier {
  List<String> favorites = [];

  void addToFavorites(String item) {
    favorites.add(item);
    notifyListeners();
  }
}
