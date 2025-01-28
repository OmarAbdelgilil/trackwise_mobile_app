import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/repos/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _authRepository;
  LoginUseCase(this._authRepository);
  Future<Result<User>> login(String email, String password) async {
    return await _authRepository.login(email, password);
  }
}
