import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:void_url_shortner/features/home/models/url_model.dart';
import 'package:void_url_shortner/shared/utils/constants.dart';

class UrlService {
  final Dio _dio;
  final Dio _s3Dio;

  UrlService() : _dio = Dio(), _s3Dio = Dio() {
    _dio.options.baseUrl = AppConstants.baseApiUrl;
    _dio.options.connectTimeout = AppConstants.apiTimeout;
    _dio.options.receiveTimeout = AppConstants.apiTimeout;

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    // A separate Dio instance for S3 uploads, without base URL or auth tokens.
    _s3Dio.options.connectTimeout = const Duration(minutes: 5);
    _s3Dio.options.receiveTimeout = const Duration(minutes: 5);
  }

  /// Handles Dio-specific errors and translates them into user-friendly exceptions.
  Exception _handleDioError(DioException e) {
    if (e.response != null && e.response!.data is Map) {
      final message =
          e.response!.data['message'] as String? ??
          'An unknown server error occurred.';
      final statusCode = e.response!.statusCode;

      switch (statusCode) {
        case 400:
          return Exception(message); // e.g., "Password is missing"
        case 401:
          return Exception(
            'The password you entered is incorrect. Please try again.',
          );
        case 404:
          return Exception(
            'This void link could not be found. It may have been deleted or never existed.',
          );
        case 409:
          return Exception(
            'Could not generate a unique link. Please try modifying your URL slightly and try again.',
          );
        case 410:
          return Exception(
            'This void link has expired and is no longer available.',
          );
        case 500:
          return Exception(
            'An internal server error occurred. Our team has been notified. Please try again later.',
          );
        default:
          return Exception(message);
      }
    } else {
      return Exception(
        'Could not connect to the server. Please check your network connection.',
      );
    }
  }

  Future<ShortCodeModel> createShortCode(ShortCodeModel shortCodeModel) async {
    try {
      final response = await _dio.post(
        '/shorten',
        data: shortCodeModel.toCreateJson(),
      );

      if (response.statusCode == 200) {
        final result = ShortCodeModel.fromCreateJson(response.data);
        // Preserve the original data (like password) and add the new data
        return shortCodeModel.copyWith(
          shortCode: result.shortCode,
          fileUploadUrl: result.fileUploadUrl,
        );
      } else {
        throw Exception('Failed to create a short code.');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> uploadFile(
    String uploadUrl,
    Uint8List fileBytes,
    String contentType,
  ) async {
    try {
      await _s3Dio.put(
        uploadUrl,
        data: Stream.fromIterable(fileBytes.map((e) => [e])),
        options: Options(
          headers: {
            Headers.contentLengthHeader: fileBytes.length,
            Headers.contentTypeHeader: contentType,
          },
        ),
      );
    } on DioException catch (e) {
      // S3 might return a more complex error structure
      throw Exception(
        'Failed to upload file. Please try again. Error: ${e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred during file upload: $e');
    }
  }

  Future<RedirectModel> getRedirectUrl(String shortCode) async {
    try {
      final response = await _dio.get('/redirect/$shortCode');

      if (response.statusCode == 200) {
        return RedirectModel.fromJson(response.data);
      } else {
        throw Exception('Failed to retrieve URL');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<VerifyPasswordResponseModel> verifyPassword(
    String shortCode,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/verify-password',
        data: {'short_code': shortCode, 'password': password},
      );

      if (response.statusCode == 200) {
        return VerifyPasswordResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to verify password.');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
