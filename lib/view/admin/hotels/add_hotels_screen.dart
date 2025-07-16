import 'package:flutter/material.dart';

import '../../../widgets/app_bar.dart';

class AddHotelsScreen extends StatelessWidget {
  const AddHotelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Add Hotels'),
      ),
      body: Center(
        child: Text('Add Hotels Screen'),
      ),
    );
  }
}
