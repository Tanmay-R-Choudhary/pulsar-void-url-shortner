import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import '../models/url_model.dart';
import '../../../services/api/url_service.dart';
import '../../../shared/utils/validators.dart';
import 'url_shortener_state.dart';

class UrlShortenerCubit extends Cubit<UrlShortenerState> {
  final UrlService _urlService;

  UrlShortenerCubit({required UrlService urlService})
    : _urlService = urlService,
      super(UrlShortenerInitial());

  Future<void> createShortCodeForUrl(
    String originalUrl, {
    String? password,
  }) async {
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

    emit(const UrlShortenerLoading(message: 'Creating your void link...'));

    try {
      final model = ShortCodeModel(
        type: ShortenType.url,
        originalUrl: originalUrl,
        password: password?.isNotEmpty == true ? password : null,
      );

      final result = await _urlService.createShortCode(model);
      emit(UrlShortenerSuccess(shortCodeModel: result));
    } on Exception catch (e) {
      emit(
        UrlShortenerError(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> createShortCodeForFile({
    required String fileName,
    required Uint8List fileBytes,
    String? password,
  }) async {
    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      emit(UrlShortenerError(message: passwordError));
      return;
    }

    emit(const UrlShortenerLoading(message: 'Requesting upload location...'));

    try {
      // 1. Create the initial model to get the upload URL
      final initialModel = ShortCodeModel(
        type: ShortenType.file,
        fileName: fileName,
        password: password?.isNotEmpty == true ? password : null,
      );

      final resultWithUploadUrl = await _urlService.createShortCode(
        initialModel,
      );

      if (resultWithUploadUrl.fileUploadUrl == null) {
        throw Exception('Server did not provide a file upload URL.');
      }

      // 2. Upload the file to the pre-signed URL
      emit(const UrlShortenerLoading(message: 'Uploading file...'));
      final contentType =
          lookupMimeType(fileName, headerBytes: fileBytes) ??
          'application/octet-stream';
      await _urlService.uploadFile(
        resultWithUploadUrl.fileUploadUrl!,
        fileBytes,
        contentType,
      );

      // 3. Emit success
      emit(UrlShortenerSuccess(shortCodeModel: resultWithUploadUrl));
    } on Exception catch (e) {
      emit(
        UrlShortenerError(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> pickAndUploadFile({String? password}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.bytes != null) {
        PlatformFile file = result.files.single;
        await createShortCodeForFile(
          fileName: file.name,
          fileBytes: file.bytes!,
          password: password,
        );
      } else {
        // User canceled the picker or file is invalid
        // No need to emit a state, just return
      }
    } catch (e) {
      emit(
        const UrlShortenerError(
          message: 'An error occurred while picking the file.',
        ),
      );
    }
  }

  Future<void> copyToClipboard(String url) async {
    try {
      ShortCodeModel? currentModel;
      if (state is UrlShortenerSuccess) {
        currentModel = (state as UrlShortenerSuccess).shortCodeModel;
      } else if (state is UrlCopiedToClipboard) {
        currentModel = (state as UrlCopiedToClipboard).shortCodeModel;
      }

      if (currentModel != null) {
        await Clipboard.setData(ClipboardData(text: url));
        emit(UrlCopiedToClipboard(shortCodeModel: currentModel));
      }
    } catch (e) {
      emit(const UrlShortenerError(message: 'Failed to copy to clipboard'));
    }
  }

  void reset() {
    emit(UrlShortenerInitial());
  }
}
