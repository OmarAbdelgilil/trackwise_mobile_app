import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/repos/auth_repository.dart';

@injectable
class RegisterUseCase {
  final AuthRepository _authRepository;
  RegisterUseCase(this._authRepository);
  Future<Result<void>> register(String email, String firstName, String lastName,
      String phoneNumber, String password, String confirmPassword) async {
    return await _authRepository.register(
        email, firstName, lastName, phoneNumber, password, confirmPassword);
  }
}
