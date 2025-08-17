import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:void_url_shortner/services/api/url_service.dart';
import 'redirect_state.dart';

class RedirectCubit extends Cubit<RedirectState> {
  final UrlService _urlService;

  RedirectCubit({required UrlService urlService})
    : _urlService = urlService,
      super(RedirectInitial());

  Future<void> processRedirect(String shortCode) async {
    emit(
      RedirectLoading(),
    ); // This is for the INITIAL page load only. It's correct here.

    try {
      final redirectModel = await _urlService.getRedirectUrl(shortCode);

      if (redirectModel.isPasswordProtected) {
        // MODIFIED: Emit our new state to show the password form.
        emit(RedirectAwaitingPassword(shortCode: shortCode));
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
    } on Exception catch (e) {
      emit(
        RedirectError(message: e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  Future<void> verifyPassword(String shortCode, String password) async {
    if (password.isEmpty) {
      // MODIFIED: Emit the same state, but with an error message.
      emit(
        RedirectAwaitingPassword(
          shortCode: shortCode,
          errorMessage: 'Please enter a password',
        ),
      );
      return;
    }

    // MODIFIED: Emit the state with the loading flag set to true.
    // The UI will stay on the password screen and show a local loading indicator.
    emit(RedirectAwaitingPassword(shortCode: shortCode, isVerifying: true));

    try {
      final originalUrl = await _urlService.verifyPasswordAndRedirect(
        shortCode,
        password,
      );
      emit(RedirectSuccess(originalUrl: originalUrl));
    } on Exception catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (errorMessage.toLowerCase().contains('incorrect')) {
        // MODIFIED: On password error, emit the state with an error message
        // and turn off the loading flag.
        emit(
          RedirectAwaitingPassword(
            shortCode: shortCode,
            isVerifying: false,
            errorMessage: errorMessage,
          ),
        );
      } else {
        // For other errors (like 404, 410), emit a fatal error.
        emit(RedirectError(message: errorMessage));
      }
    }
  }

  void reset() {
    emit(RedirectInitial());
  }
}
