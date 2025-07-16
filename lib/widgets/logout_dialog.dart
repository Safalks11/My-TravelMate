import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/firebase_helper/firebase_helper.dart';
import '../view/splash_screen/splash_screen_view.dart';
import 'help_snackbar.dart';

void showLogoutDialog(BuildContext context, userLogout) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dialog from closing on tap outside
    builder: (context) => AlertDialog(
      title: const Text('Logout Confirmation'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Close dialog
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            userLogout == true
                ? FirebaseHelper().logout().then((value) {
                    Get.offAll(SplashScreen());
                    showHelp(context, "Logged out!", "You have logged out...");
                  })
                : Navigator.pop(context);
            Get.offAll(() => const SplashScreen());
          },
          style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
          child: const Text('Logout'),
        ),
      ],
    ),
  );
}
