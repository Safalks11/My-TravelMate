import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void showComingSoonDialog() {
  Get.dialog(AlertDialog(
    title: Text('Coming Soon'),
    actions: [
      TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Ok'))
    ],
  ));
}
