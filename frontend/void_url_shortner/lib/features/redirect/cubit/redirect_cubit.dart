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
        emit(RedirectAwaitingPassword(shortCode: shortCode));
      } else {
        if (redirectModel.destinationUrl != null &&
            redirectModel.destinationUrl!.isNotEmpty) {
          emit(
            RedirectSuccess(
              destinationUrl: redirectModel.destinationUrl!,
              isFile: redirectModel.isFile,
            ),
          );
        } else {
          emit(
            const RedirectError(
              message: 'Could not retrieve the destination location.',
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
      emit(
        RedirectAwaitingPassword(
          shortCode: shortCode,
          errorMessage: 'Please enter a password',
        ),
      );
      return;
    }

    emit(RedirectAwaitingPassword(shortCode: shortCode, isVerifying: true));

    try {
      // CORRECTED: Call the new 'verifyPassword' method
      final responseModel = await _urlService.verifyPassword(
        shortCode,
        password,
      );

      // CORRECTED: Handle the new 'VerifyPasswordResponseModel'
      if (responseModel.destinationUrl != null &&
          responseModel.destinationUrl!.isNotEmpty) {
        emit(
          RedirectSuccess(
            destinationUrl: responseModel.destinationUrl!,
            isFile: responseModel.isFile,
          ),
        );
      } else {
        throw Exception(
          'Password verified, but no destination URL was returned.',
        );
      }
    } on Exception catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (errorMessage.toLowerCase().contains('incorrect')) {
        emit(
          RedirectAwaitingPassword(
            shortCode: shortCode,
            isVerifying: false,
            errorMessage: errorMessage,
          ),
        );
      } else {
        emit(RedirectError(message: errorMessage));
      }
    }
  }

  void reset() {
    emit(RedirectInitial());
  }
}
