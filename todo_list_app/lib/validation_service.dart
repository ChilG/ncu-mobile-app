class ValidationService {
  /// Checks if a string value is valid (not null, not empty, and not only whitespace).
  bool isValidString(String? value) {
    if (value == null) {
      return false;
    }
    return value.trim().isNotEmpty;
  }
}
