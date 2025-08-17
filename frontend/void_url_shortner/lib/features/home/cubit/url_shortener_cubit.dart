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
      UrlModel? currentModel;
      if (state is UrlShortenerSuccess) {
        currentModel = (state as UrlShortenerSuccess).urlModel;
      } else if (state is UrlCopiedToClipboard) {
        currentModel = (state as UrlCopiedToClipboard).urlModel;
      }

      if (currentModel != null) {
        await Clipboard.setData(ClipboardData(text: url));
        emit(UrlCopiedToClipboard(urlModel: currentModel));
      }
    } catch (e) {
      emit(const UrlShortenerError(message: 'Failed to copy to clipboard'));
    }
  }

  void reset() {
    emit(UrlShortenerInitial());
  }
}
