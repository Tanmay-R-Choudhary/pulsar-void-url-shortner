import 'package:dio/dio.dart';
import 'package:void_url_shortner/features/home/models/url_model.dart';
import 'package:void_url_shortner/shared/utils/constants.dart';

class UrlService {
  final Dio _dio;

  UrlService() : _dio = Dio() {
    _dio.options.baseUrl = AppConstants.baseApiUrl;
    _dio.options.connectTimeout = AppConstants.apiTimeout;
    _dio.options.receiveTimeout = AppConstants.apiTimeout;

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<UrlModel> shortenUrl(UrlModel urlModel) async {
    try {
      final response = await _dio.post('/shorten', data: urlModel.toJson());

      if (response.statusCode == 200) {
        return UrlModel.fromJson(response.data);
      } else {
        throw Exception('Failed to shorten URL');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Server error: ${e.response!.data['message'] ?? 'Unknown error'}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<RedirectModel> getRedirectUrl(String shortCode) async {
    try {
      final response = await _dio.get('/redirect/$shortCode');

      if (response.statusCode == 200) {
        return RedirectModel.fromJson(response.data);
      } else {
        throw Exception('URL not found');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Short URL not found');
      } else if (e.response != null) {
        throw Exception(
          'Server error: ${e.response!.data['message'] ?? 'Unknown error'}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<String> verifyPasswordAndRedirect(
    String shortCode,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/verify-password',
        data: {'short_code': shortCode, 'password': password},
      );

      if (response.statusCode == 200) {
        return response.data['original_url'];
      } else {
        throw Exception('Invalid password');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid password');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Short URL not found');
      } else if (e.response != null) {
        throw Exception(
          'Server error: ${e.response!.data['message'] ?? 'Unknown error'}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
