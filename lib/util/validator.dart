class Validator {
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter your full name';
    }
    final words = value.trim().split(' ');
    if (words.length != 2) {
      return '🚫 Please enter your full name (first name and last name)';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter your email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '🚫 Please enter a valid email address';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter your phone number';
    }
    // You can add more sophisticated phone number validation logic here
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter the OTP';
    }
    // You can add more sophisticated phone number validation logic here
    return null;
  }

  static String? validateProverb(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter a proverb.';
    }
    // You can add more sophisticated phone number validation logic here
    return null;
  }

  static String? validateMythAndExample(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter a myth or example.';
    }
    // You can add more sophisticated phone number validation logic here
    return null;
  }

  static String? validateRiddle(String? riddle) {
    if (riddle == null || riddle.isEmpty) {
      return '🚫 Please enter a proverb.';
    }
    // You can add more sophisticated phone number validation logic here
    return null;
  }

  static String? validateRiddleAnswer(String? answer) {
    if (answer == null || answer.isEmpty) {
      return '🚫 Please enter the answer.';
    }
    // You can add more sophisticated phone number validation logic here
    return null;
  }

  static String? validateStoryTitle(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter a title.';
    }
    // You can add more sophisticated phone number validation logic here
    return null;
  }

  static String? validateStoryContent(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter a story.';
    }
    // You can add more sophisticated phone number validation logic here
    return null;
  }

  static String? validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter your birth date';
    }
    // You can add more sophisticated birth date validation logic here
    return null;
  }

  static String? validateCountry(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter your country';
    }
    // You can add more sophisticated country validation logic here
    return null;
  }

  static String? validateCitizenship(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter your citizenship';
    }
    // You can add more sophisticated citizenship validation logic here
    return null;
  }

  static String? validateDefinition(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter a definition';
    }
    // You can add more sophisticated definition validation logic here
    return null;
  }

  static String? validateWord(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter a word';
    }
    // You can add more sophisticated word validation logic here
    return null;
  }

  static String? validateAlphabet(int? value) {
    if (value == null || value == 0) {
      return '🚫 Please enter an alphabet';
    }
    // You can add more sophisticated alphabet validation logic here
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '🚫 Please enter a password';
    }
    /*final minLengthRegex = RegExp(r'^.{8,}$');
    final digitRegex = RegExp(r'\d');
    final lowercaseRegex = RegExp(r'[a-z]');
    final uppercaseRegex = RegExp(r'[A-Z]');
    final specialCharRegex = RegExp(r'[!@#$%^&*-]');
    if (!minLengthRegex.hasMatch(value)) {
      return '🚫 Password must be at least 8 characters long.';
    }
    if (!digitRegex.hasMatch(value)) {
      return '🚫 Password must contain at least one number (0-9).';
    }
    if (!lowercaseRegex.hasMatch(value)) {
      return '🚫 Password must contain at least one lowercase letter (a-z).';
    }
    if (!uppercaseRegex.hasMatch(value)) {
      return '🚫 Password must contain at least one uppercase letter (A-Z).';
    }
    if (!specialCharRegex.hasMatch(value)) {
      return '🚫 Password must contain at least one special character (!@#\$%^&*-).';
    }*/

    return null;
  }

  static String? validatePasswordMatch(String? value, String? newPassword) {
    if (value != newPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}
