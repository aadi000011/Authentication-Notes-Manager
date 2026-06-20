import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> watchAuthUser();

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}
