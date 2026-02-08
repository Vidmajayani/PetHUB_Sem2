class NameValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    } else if (value.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }
}