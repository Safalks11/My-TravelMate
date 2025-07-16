import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        SalomonBottomBarItem(
          icon: Icon(Icons.home_outlined),
          title: Text("Home"),
          selectedColor: Colors.purple,
        ),
        SalomonBottomBarItem(
          icon: Icon(Icons.list_alt_outlined),
          title: Text("Hotels"),
          selectedColor: Colors.teal,
        ),
        SalomonBottomBarItem(
          icon: Icon(Icons.mode_of_travel),
          title: Text("Trips"),
          selectedColor: Colors.blueAccent,
        ),
        SalomonBottomBarItem(
          icon: Icon(Icons.help_outline),
          title: Text("Help"),
          selectedColor: Colors.red,
        ),
      ],
    );
  }
}
