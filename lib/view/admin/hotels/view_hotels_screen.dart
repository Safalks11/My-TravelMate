import 'package:flutter/material.dart';

import '../../../widgets/app_bar.dart';

class ViewHotelsScreen extends StatelessWidget {
  const ViewHotelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('View Hotels'),
      ),
      body: Center(
        child: Text('View Hotels Screen'),
      ),
    );
  }
}
