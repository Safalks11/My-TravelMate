import 'package:flutter/material.dart';

import '../../../widgets/app_bar.dart';

class AddPlacesScreen extends StatelessWidget {
  const AddPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Add Places'),
      ),
      body: Center(
        child: Text('Add Places Screen'),
      ),
    );
  }
}
