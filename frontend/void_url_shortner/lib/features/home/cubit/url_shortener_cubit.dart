import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import '../models/url_model.dart';
import '../../../services/api/url_service.dart';
import '../../../shared/utils/validators.dart';
import 'url_shortener_state.dart';

class UrlShortenerCubit extends Cubit<UrlShortenerState> {
  final UrlService _urlService;

  UrlShortenerCubit({required UrlService urlService})
    : _urlService = urlService,
      super(UrlShortenerInitial());

  Future<void> shortenUrl(String originalUrl, {String? password}) async {
    final urlError = Validators.validateUrl(originalUrl);
    if (urlError != null) {
      emit(UrlShortenerError(message: urlError));
      return;
    }

    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      emit(UrlShortenerError(message: passwordError));
      return;
    }

    emit(UrlShortenerLoading());

    try {
      final urlModel = UrlModel(
        originalUrl: originalUrl,
        password: password?.isNotEmpty == true ? password : null,
      );

      final result = await _urlService.shortenUrl(urlModel);
      emit(UrlShortenerSuccess(urlModel: result));
    } catch (e) {
      emit(
        UrlShortenerError(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> copyToClipboard(String url) async {
    try {
      await Clipboard.setData(ClipboardData(text: url));
      emit(UrlCopiedToClipboard(copiedUrl: url));

      await Future.delayed(const Duration(seconds: 2));
      if (state is UrlCopiedToClipboard) {
        final shortCode = url.split('/').last;
        final urlModel = UrlModel(originalUrl: '', shortCode: shortCode);
        emit(UrlShortenerSuccess(urlModel: urlModel));
      }
    } catch (e) {
      emit(const UrlShortenerError(message: 'Failed to copy to clipboard'));
    }
  }

  void reset() {
    emit(UrlShortenerInitial());
  }
}
