import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/repos/auth_repository.dart';

@injectable
class CheckUserCacheUseCase {
  final AuthRepository _authRepository;
  CheckUserCacheUseCase(this._authRepository);

  Future<void> checkCache() async {
    await _authRepository.checkCache();
  }
}
