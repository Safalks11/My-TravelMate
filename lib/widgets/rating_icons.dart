import 'package:flutter/material.dart';

List<Widget> buildRatingIcons(num rating) {
  List<Widget> icons = [];

  // Calculate the number of full stars
  int fullStars = rating.floor();

  // Add full stars
  for (int i = 0; i < fullStars; i++) {
    icons.add(
      Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );
  }

  // Check for a half star
  if (rating - fullStars >= 0.5) {
    icons.add(
      Icon(
        Icons.star_half,
        color: Colors.amber,
      ),
    );
  }

  // Add empty stars to fill the row
  for (int i = icons.length; i < 5; i++) {
    icons.add(
      Icon(
        Icons.star_border,
        color: Colors.amber,
      ),
    );
  }

  return icons;
}
