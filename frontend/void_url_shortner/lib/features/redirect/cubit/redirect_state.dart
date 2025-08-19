import 'package:equatable/equatable.dart';

abstract class RedirectState extends Equatable {
  const RedirectState();

  @override
  List<Object?> get props => [];
}

class RedirectInitial extends RedirectState {}

class RedirectLoading extends RedirectState {}

class RedirectAwaitingPassword extends RedirectState {
  final String shortCode;
  final bool isVerifying;
  final String? errorMessage;

  const RedirectAwaitingPassword({
    required this.shortCode,
    this.isVerifying = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [shortCode, isVerifying, errorMessage];
}

class RedirectSuccess extends RedirectState {
  final String destinationUrl;
  final bool isFile;

  const RedirectSuccess({required this.destinationUrl, required this.isFile});

  @override
  List<Object?> get props => [destinationUrl, isFile];
}

class RedirectError extends RedirectState {
  final String message;

  const RedirectError({required this.message});

  @override
  List<Object?> get props => [message];
}
