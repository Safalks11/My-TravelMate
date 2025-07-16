import 'package:flutter/material.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Map<String, dynamic>> favoritesList = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Your favourite content goes here!'),
    );
  }
}
