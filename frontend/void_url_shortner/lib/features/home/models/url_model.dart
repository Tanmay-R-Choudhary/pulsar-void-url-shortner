import 'package:equatable/equatable.dart';
import 'package:void_url_shortner/shared/utils/constants.dart';

enum ShortenType { url, file }

class ShortCodeModel extends Equatable {
  final ShortenType type;
  final String? originalUrl;
  final String? fileName;
  final String? password;
  final String? shortCode;
  final String? fileUploadUrl;

  const ShortCodeModel({
    this.type = ShortenType.url,
    this.originalUrl,
    this.fileName,
    this.password,
    this.shortCode,
    this.fileUploadUrl,
  });

  String get shortenedUrl {
    if (shortCode == null) return '';
    return '${AppConstants.domain}/$shortCode';
  }

  ShortCodeModel copyWith({
    ShortenType? type,
    String? originalUrl,
    String? fileName,
    String? password,
    String? shortCode,
    String? fileUploadUrl,
    bool clearPassword = false,
  }) {
    return ShortCodeModel(
      type: type ?? this.type,
      originalUrl: originalUrl ?? this.originalUrl,
      fileName: fileName ?? this.fileName,
      password: clearPassword ? null : password ?? this.password,
      shortCode: shortCode ?? this.shortCode,
      fileUploadUrl: fileUploadUrl ?? this.fileUploadUrl,
    );
  }

  Map<String, dynamic> toCreateJson() {
    final isFile = type == ShortenType.file;
    return {
      'is_file': isFile,
      if (!isFile) 'original_url': originalUrl,
      if (isFile) 'filename': fileName,
      if (password != null && password!.isNotEmpty) 'password': password,
    };
  }

  factory ShortCodeModel.fromCreateJson(Map<String, dynamic> json) {
    return ShortCodeModel(
      type: json['is_file'] ? ShortenType.file : ShortenType.url,
      shortCode: json['short_code'],
      originalUrl: json['original_url'],
      fileUploadUrl: json['file_upload_url'],
    );
  }

  @override
  List<Object?> get props => [
    type,
    originalUrl,
    fileName,
    password,
    shortCode,
    fileUploadUrl,
  ];
}

class RedirectModel extends Equatable {
  final bool isPasswordProtected;
  final bool isFile;
  final String? longUrl;
  final String? fileDownloadUrl;

  const RedirectModel({
    required this.isPasswordProtected,
    required this.isFile,
    this.longUrl,
    this.fileDownloadUrl,
  });

  String? get destinationUrl => isFile ? fileDownloadUrl : longUrl;

  factory RedirectModel.fromJson(Map<String, dynamic> json) {
    return RedirectModel(
      isPasswordProtected: json['is_password_protected'] ?? false,
      isFile: json['is_file'] ?? false,
      longUrl: json['original_url'],
      fileDownloadUrl: json['file_download_url'],
    );
  }

  @override
  List<Object?> get props => [
    isPasswordProtected,
    isFile,
    longUrl,
    fileDownloadUrl,
  ];
}

class VerifyPasswordResponseModel extends Equatable {
  final bool isFile;
  final String? longUrl;
  final String? fileDownloadUrl;

  const VerifyPasswordResponseModel({
    required this.isFile,
    this.longUrl,
    this.fileDownloadUrl,
  });

  String? get destinationUrl => isFile ? fileDownloadUrl : longUrl;

  factory VerifyPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyPasswordResponseModel(
      isFile: json['is_file'] ?? false,
      longUrl: json['original_url'],
      fileDownloadUrl: json['file_download_url'],
    );
  }

  @override
  List<Object?> get props => [isFile, longUrl, fileDownloadUrl];
}
