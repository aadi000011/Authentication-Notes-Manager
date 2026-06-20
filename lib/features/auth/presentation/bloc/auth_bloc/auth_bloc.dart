import 'dart:async';

import 'package:authentication_notes_manager/features/auth/domain/entities/app_user.dart';
import 'package:authentication_notes_manager/features/auth/domain/usecases/login_usecase.dart';
import 'package:authentication_notes_manager/features/auth/domain/usecases/logout_usecase.dart';
import 'package:authentication_notes_manager/features/auth/domain/usecases/signup_usecase.dart';
import 'package:authentication_notes_manager/features/auth/domain/usecases/watch_auth_user_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignupUseCase signupUseCase,
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required WatchAuthUserUseCase watchAuthUserUseCase,
  })  : _signupUseCase = signupUseCase,
        _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _watchAuthUserUseCase = watchAuthUserUseCase,
        super(const AuthState.checking()) {
    on<AuthStarted>(_onStarted);
    on<_AuthUserChanged>(_onUserChanged);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final SignupUseCase _signupUseCase;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final WatchAuthUserUseCase _watchAuthUserUseCase;

  StreamSubscription<AppUser?>? _authSubscription;

  void _onStarted(AuthStarted event, Emitter<AuthState> emit) {
    _authSubscription?.cancel();
    _authSubscription = _watchAuthUserUseCase().listen(
      (user) => add(_AuthUserChanged(user)),
    );
  }

  void _onUserChanged(_AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthState.authenticated(event.user!));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _signupUseCase(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      );
      // Auth state update is handled via _AuthUserChanged from the stream
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: _mapAuthError(error),
      ));
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _loginUseCase(email: event.email, password: event.password);
      // Auth state update is handled via _AuthUserChanged from the stream
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: _mapAuthError(error),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _logoutUseCase();
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: _mapAuthError(error),
      ));
    }
  }

  String _mapAuthError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'invalid-email':
          return 'Invalid email format.';
        case 'weak-password':
          return 'Password must be at least 6 characters.';
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          return 'Invalid email or password.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        default:
          return error.message ?? 'Authentication failed.';
      }
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}