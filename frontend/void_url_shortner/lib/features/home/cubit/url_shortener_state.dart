import 'package:equatable/equatable.dart';
import 'package:void_url_shortner/features/home/models/url_model.dart';

abstract class UrlShortenerState extends Equatable {
  const UrlShortenerState();

  @override
  List<Object?> get props => [];
}

class UrlShortenerInitial extends UrlShortenerState {}

class UrlShortenerLoading extends UrlShortenerState {
  final String message;
  const UrlShortenerLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class UrlShortenerSuccess extends UrlShortenerState {
  final ShortCodeModel shortCodeModel;

  const UrlShortenerSuccess({required this.shortCodeModel});

  @override
  List<Object?> get props => [shortCodeModel];
}

class UrlShortenerError extends UrlShortenerState {
  final String message;

  const UrlShortenerError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UrlCopiedToClipboard extends UrlShortenerState {
  final ShortCodeModel shortCodeModel;
  final int timestamp;

  UrlCopiedToClipboard({required this.shortCodeModel})
    : timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object?> get props => [shortCodeModel, timestamp];
}
