import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:void_url_shortner/services/api/url_service.dart';
import 'redirect_state.dart';

class RedirectCubit extends Cubit<RedirectState> {
  final UrlService _urlService;

  RedirectCubit({required UrlService urlService})
    : _urlService = urlService,
      super(RedirectInitial());

  Future<void> processRedirect(String shortCode) async {
    emit(RedirectLoading());

    try {
      final redirectModel = await _urlService.getRedirectUrl(shortCode);

      if (redirectModel.isPasswordProtected) {
        emit(RedirectPasswordRequired(shortCode: shortCode));
      } else {
        if (redirectModel.originalUrl != null &&
            redirectModel.originalUrl!.isNotEmpty) {
          emit(RedirectSuccess(originalUrl: redirectModel.originalUrl!));
        } else {
          emit(
            const RedirectError(
              message: 'Could not retrieve the original URL.',
            ),
          );
        }
      }
    } catch (e) {
      emit(
        RedirectError(message: e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  Future<void> verifyPassword(String shortCode, String password) async {
    if (password.isEmpty) {
      emit(
        RedirectPasswordError(
          shortCode: shortCode,
          message: 'Please enter a password',
        ),
      );
      return;
    }

    emit(RedirectLoading());

    try {
      final originalUrl = await _urlService.verifyPasswordAndRedirect(
        shortCode,
        password,
      );
      emit(RedirectSuccess(originalUrl: originalUrl));
    } catch (e) {
      emit(
        RedirectPasswordError(
          shortCode: shortCode,
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void reset() {
    emit(RedirectInitial());
  }
}
