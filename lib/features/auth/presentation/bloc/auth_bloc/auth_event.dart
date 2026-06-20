part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class AuthStarted extends AuthEvent {}

final class AuthSignupRequested extends AuthEvent {
  AuthSignupRequested({
    required this.fullName,
    required this.email,
    required this.password,
  });

  final String fullName;
  final String email;
  final String password;
}

final class AuthLoginRequested extends AuthEvent {
  AuthLoginRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

final class AuthLogoutRequested extends AuthEvent {}

final class _AuthUserChanged extends AuthEvent {
  _AuthUserChanged(this.user);
  final AppUser? user;
}