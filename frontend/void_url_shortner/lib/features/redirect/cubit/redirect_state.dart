import 'package:equatable/equatable.dart';

abstract class RedirectState extends Equatable {
  const RedirectState();

  @override
  List<Object?> get props => [];
}

class RedirectInitial extends RedirectState {}

class RedirectLoading extends RedirectState {}

// REMOVED: These two states will be replaced.
// class RedirectPasswordRequired extends RedirectState { ... }
// class RedirectPasswordError extends RedirectState { ... }

// ADDED: A new, comprehensive state for the password screen.
class RedirectAwaitingPassword extends RedirectState {
  final String shortCode;
  final bool isVerifying;
  final String? errorMessage;

  const RedirectAwaitingPassword({
    required this.shortCode,
    this.isVerifying = false, // Indicates if the password is being checked
    this.errorMessage, // Holds the error message for incorrect passwords
  });

  @override
  List<Object?> get props => [shortCode, isVerifying, errorMessage];
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
