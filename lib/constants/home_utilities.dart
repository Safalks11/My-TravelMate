import 'package:flutter/material.dart';

class HomeData {
  static final List<Color> gridItemColors = [
    Colors.deepPurple.shade100,
    Colors.brown.shade100,
    Colors.grey.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.orange.shade100,
    // Add more colors as needed
  ];

  static final List<String> category = [
    'assets/bg_images/eiffel-tower.png',
    'assets/bg_images/mountain.png',
    'assets/bg_images/landscape.png',
    'assets/bg_images/sea.png'
  ];

  static final List<String> catName = [
    "Work of art",
    "Uphills",
    "Nature",
    "Sea & Beach"
  ];

  static final List<Color?> catColors = [
    Colors.pink[100],
    Colors.indigo[100],
    Colors.green[100],
    Colors.blue[100]
  ];
}
