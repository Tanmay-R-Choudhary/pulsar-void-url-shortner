import 'package:equatable/equatable.dart';

abstract class RedirectState extends Equatable {
  const RedirectState();

  @override
  List<Object?> get props => [];
}

class RedirectInitial extends RedirectState {}

class RedirectLoading extends RedirectState {}

class RedirectPasswordRequired extends RedirectState {
  final String shortCode;

  const RedirectPasswordRequired({required this.shortCode});

  @override
  List<Object?> get props => [shortCode];
}

class RedirectSuccess extends RedirectState {
  final String originalUrl;

  const RedirectSuccess({required this.originalUrl});

  @override
  List<Object?> get props => [originalUrl];
}

class RedirectError extends RedirectState {
  final String message;

  const RedirectError({required this.message});

  @override
  List<Object?> get props => [message];
}

class RedirectPasswordError extends RedirectState {
  final String shortCode;
  final String message;

  const RedirectPasswordError({required this.shortCode, required this.message});

  @override
  List<Object?> get props => [shortCode, message];
}
