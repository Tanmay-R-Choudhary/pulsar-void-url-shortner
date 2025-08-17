import 'package:equatable/equatable.dart';
import 'package:void_url_shortner/shared/utils/constants.dart';

class UrlModel extends Equatable {
  final String originalUrl;
  final String? password;
  final String? shortCode;

  const UrlModel({required this.originalUrl, this.password, this.shortCode});

  String get shortenedUrl {
    if (shortCode == null) return '';
    return '${AppConstants.domain}/$shortCode';
  }

  UrlModel copyWith({
    String? originalUrl,
    String? password,
    String? shortCode,
  }) {
    return UrlModel(
      originalUrl: originalUrl ?? this.originalUrl,
      password: password ?? this.password,
      shortCode: shortCode ?? this.shortCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original_url': originalUrl,
      if (password != null) 'password': password,
    };
  }

  factory UrlModel.fromJson(Map<String, dynamic> json) {
    return UrlModel(
      originalUrl: json['original_url'] ?? '',
      password: json['password'],
      shortCode: json['short_code'],
    );
  }

  @override
  List<Object?> get props => [originalUrl, password, shortCode];
}

class RedirectModel extends Equatable {
  final String? originalUrl;
  final bool isPasswordProtected;

  const RedirectModel({this.originalUrl, required this.isPasswordProtected});

  factory RedirectModel.fromJson(Map<String, dynamic> json) {
    return RedirectModel(
      originalUrl: json['original_url'],
      isPasswordProtected: json['is_password_protected'] ?? false,
    );
  }

  @override
  List<Object?> get props => [originalUrl, isPasswordProtected];
}
