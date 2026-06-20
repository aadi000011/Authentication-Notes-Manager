// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';

// import '../../domain/entities/app_user.dart';
// import '../../domain/usecases/login_usecase.dart';
// import '../../domain/usecases/logout_usecase.dart';
// import '../../domain/usecases/signup_usecase.dart';
// import '../../domain/usecases/watch_auth_user_usecase.dart';

// class AuthController extends ChangeNotifier {
//   AuthController({
//     required SignupUseCase signupUseCase,
//     required LoginUseCase loginUseCase,
//     required LogoutUseCase logoutUseCase,
//     required WatchAuthUserUseCase watchAuthUserUseCase,
//   })  : _signupUseCase = signupUseCase,
//         _loginUseCase = loginUseCase,
//         _logoutUseCase = logoutUseCase,
//         _watchAuthUserUseCase = watchAuthUserUseCase {
//     _authSubscription = _watchAuthUserUseCase().listen((user) {
//       _currentUser = user;
//       _isCheckingSession = false;
//       notifyListeners();
//     });
//   }

//   final SignupUseCase _signupUseCase;
//   final LoginUseCase _loginUseCase;
//   final LogoutUseCase _logoutUseCase;
//   final WatchAuthUserUseCase _watchAuthUserUseCase;

//   StreamSubscription<AppUser?>? _authSubscription;
//   AppUser? _currentUser;
//   bool _isLoading = false;
//   bool _isCheckingSession = true;
//   String? _errorMessage;

//   AppUser? get currentUser => _currentUser;
//   bool get isLoading => _isLoading;
//   bool get isCheckingSession => _isCheckingSession;
//   String? get errorMessage => _errorMessage;

//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }

//   Future<bool> signup({
//     required String fullName,
//     required String email,
//     required String password,
//   }) async {
//     _setLoading(true);
//     try {
//       await _signupUseCase(
//         fullName: fullName,
//         email: email,
//         password: password,
//       );
//       _errorMessage = null;
//       return true;
//     } catch (error) {
//       _errorMessage = _mapAuthError(error);
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<bool> login({
//     required String email,
//     required String password,
//   }) async {
//     _setLoading(true);
//     try {
//       await _loginUseCase(email: email, password: password);
//       _errorMessage = null;
//       return true;
//     } catch (error) {
//       _errorMessage = _mapAuthError(error);
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> logout() async {
//     _setLoading(true);
//     try {
//       await _logoutUseCase();
//       _errorMessage = null;
//     } catch (error) {
//       _errorMessage = _mapAuthError(error);
//     } finally {
//       _setLoading(false);
//     }
//   }

//   void _setLoading(bool isLoading) {
//     _isLoading = isLoading;
//     notifyListeners();
//   }

//   String _mapAuthError(Object error) {
//     if (error is FirebaseAuthException) {
//       switch (error.code) {
//         case 'email-already-in-use':
//           return 'This email is already registered.';
//         case 'invalid-email':
//           return 'Invalid email format.';
//         case 'weak-password':
//           return 'Password must be at least 6 characters.';
//         case 'invalid-credential':
//         case 'wrong-password':
//         case 'user-not-found':
//           return 'Invalid email or password.';
//         case 'network-request-failed':
//           return 'Network error. Please check your internet connection.';
//         default:
//           return error.message ?? 'Authentication failed.';
//       }
//     }
//     return 'Something went wrong. Please try again.';
//   }

//   @override
//   void dispose() {
//     _authSubscription?.cancel();
//     super.dispose();
//   }
// }
