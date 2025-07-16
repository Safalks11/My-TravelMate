import 'package:flutter/material.dart';

Widget buildSectionTitle(String title) {
  return Row(
    children: [
      SizedBox(width: 10),
      Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
      ),
    ],
  );
}
