import '../repositories/auth_repository.dart';

class SignupUseCase {
  SignupUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _repository.signup(
      fullName: fullName,
      email: email,
      password: password,
    );
  }
}
