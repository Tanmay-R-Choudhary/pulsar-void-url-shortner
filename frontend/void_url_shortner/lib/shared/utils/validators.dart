class Validators {
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  static bool isValidPassword(String password) {
    return password.isNotEmpty && password.length >= 4;
  }

  static String? validateUrl(String? url) {
    if (url == null || url.isEmpty) {
      return 'Please enter a URL';
    }

    if (!isValidUrl(url)) {
      return 'Please enter a valid URL (include http:// or https://)';
    }

    if (url.length > 2048) {
      return 'URL is too long (maximum 2048 characters)';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password != null && password.isNotEmpty && password.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }
}
