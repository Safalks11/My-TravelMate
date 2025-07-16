class FormValidator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter the name!!";
    }
    return null;
  }

  static String? simpleEmailValidator(String? value) {
    // Check if the email is null or empty
    if (value == null || value.isEmpty) {
      return 'Email is required!';
    }

    // Regular expression for validating Gmail addresses
    final gmailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@gmail\.com$',
    );

    // Validate the email against the regex
    if (!gmailRegExp.hasMatch(value)) {
      return 'Please enter a valid Gmail address!';
    }

    return null; // Return null if the email is valid
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty || value.length < 6) {
      return "Please enter a valid password!!";
    }
    return null;
  }

  static String? validateConfirmPassword(
      String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return "Please re-enter your password!!";
    } else if (value != originalPassword) {
      return "Confirm password must be same as the entered password!!";
    }
    return null;
  }
}
