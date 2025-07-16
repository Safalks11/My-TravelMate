import 'package:flutter/material.dart';
import 'package:main_project/widgets/app_bar.dart';

class ViewPlacesScreen extends StatelessWidget {
  const ViewPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('View Places'),
      ),
      body: Center(
        child: Text('View Places Screen'),
      ),
    );
  }
}
