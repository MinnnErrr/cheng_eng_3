class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? Function(String?) maxLength(int max) {
    return (String? value) {
      if (value == null) return null; 
      if (value.length > max) {
        return 'Max $max characters allowed';
      }
      return null;
    };
  }

  static String? isInt(String? value) {
    if (value == null || value.isEmpty) return null;
    final number = int.tryParse(value);
    if (number == null) {
      return 'Please enter a valid whole number';
    }
    return null;
  }

  static String? isFloat(String? value) {
    if (value == null || value.isEmpty) return null;
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  static String? postcode(String? value) {
    if (value == null || value.isEmpty) return null;
    // Regex: Exactly 5 digits
    final regex = RegExp(r'^\d{5}$');
    if (!regex.hasMatch(value)) {
      return 'Enter a valid 5-digit postcode';
    }
    return null;
  }
}
