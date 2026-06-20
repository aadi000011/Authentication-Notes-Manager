import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AppUser?> watchAuthUser() {
    return _remoteDataSource.watchAuthUser();
  }

  @override
  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signup(
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return _remoteDataSource.logout();
  }
}
