import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/Auth/data/contracts/online_data_source.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/repos/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final OnlineDataSource _onlineDataSource;
  AuthRepositoryImpl(this._onlineDataSource);

  @override
  Future<Result<User>> login(String email, String password) async {
    return await _onlineDataSource.login(email, password);
  }
}
