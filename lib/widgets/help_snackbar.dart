import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void showHelp(BuildContext context, String title, String message) {
  final snackBar = SnackBar(
    /// Properties for the best effect with `AwesomeSnackbarContent`
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,

      /// Accepts `ContentType` for flexibility (failure, success, warning, help)
      contentType: ContentType.help,
    ),
  );

  /// Display the snackbar using `ScaffoldMessenger`
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar() // Hides any active snackbar
    ..showSnackBar(snackBar);
}
