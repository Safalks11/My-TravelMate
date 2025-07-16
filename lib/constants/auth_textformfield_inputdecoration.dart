import 'package:flutter/material.dart';

InputDecoration buildInputDecoration({
  required String hintText,
  required IconData prefixIcon,
  Widget? suffixIcon,
  VoidCallback? suffixIconOnTap,
  String? helperText,
}) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(10))),
    hintText: hintText,
    hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
    helperText: helperText,
    helperStyle: TextStyle(color: Colors.grey.shade700),
    prefixIcon: Icon(prefixIcon),
    suffixIcon: suffixIcon,
  );
}
