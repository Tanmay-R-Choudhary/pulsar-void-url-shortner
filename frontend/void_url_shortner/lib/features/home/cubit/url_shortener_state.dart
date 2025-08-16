import 'package:equatable/equatable.dart';
import 'package:void_url_shortner/features/home/models/url_model.dart';

abstract class UrlShortenerState extends Equatable {
  const UrlShortenerState();

  @override
  List<Object?> get props => [];
}

class UrlShortenerInitial extends UrlShortenerState {}

class UrlShortenerLoading extends UrlShortenerState {}

class UrlShortenerSuccess extends UrlShortenerState {
  final UrlModel urlModel;

  const UrlShortenerSuccess({required this.urlModel});

  @override
  List<Object?> get props => [urlModel];
}

class UrlShortenerError extends UrlShortenerState {
  final String message;

  const UrlShortenerError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UrlCopiedToClipboard extends UrlShortenerState {
  final String copiedUrl;

  const UrlCopiedToClipboard({required this.copiedUrl});

  @override
  List<Object?> get props => [copiedUrl];
}
