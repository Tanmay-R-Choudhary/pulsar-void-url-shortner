import 'package:flutter/foundation.dart';

class AppConstants {
  static const String appName = 'void';
  static const String baseApiUrl = 'http://localhost:8080/api';
  static String domain =
      kReleaseMode
          ? "${Uri.base.scheme}://${Uri.base.host}"
          : "${Uri.base.scheme}://${Uri.base.host}:${Uri.base.port}";
  static const Duration apiTimeout = Duration(seconds: 10);

  static const String appVersion = '1.0.0';
  static const String projectName = 'pulsar';

  static const int maxUrlLength = 2048;
  static const int shortCodeLength = 5;
  static const int urlExpirationHours = 2;
}
