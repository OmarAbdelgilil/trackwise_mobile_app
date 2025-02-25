import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/repos/auth_repository.dart';

@injectable
class LogoutUseCase {
  final AuthRepository _authRepository;
  LogoutUseCase(this._authRepository);

  Future<void> logout() async {
    await _authRepository.logout();
  }
}
