// import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/core/provider/user_provider.dart';
import 'package:track_wise_mobile_app/features/Auth/data/contracts/offline_data_source.dart';
import 'package:track_wise_mobile_app/features/Auth/data/contracts/online_data_source.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/repos/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final OnlineDataSource _onlineDataSource;
  final OfflineDataSource _offlineDataSource;
  final ProviderContainer _providerContainer = ProviderContainer();
  static const platform = MethodChannel('usage_stats');
  AuthRepositoryImpl(this._onlineDataSource, this._offlineDataSource);

  @override
  Future<Result<User>> login(String email, String password) async {
    final Result<(User, String)> result =
        await _onlineDataSource.login(email, password);

    if (result is Success<(User, String)>) {
      final user = result.data!.$1;
      final token = result.data!.$2;
      _providerContainer.read(userProvider.notifier).setUser(user, token);
      await _offlineDataSource.saveToken(token);
      //platform.invokeMethod('startBackgroundService', {'token': token});
      return Success(user);
    }

    return Fail((result as Fail).exception);
  }

  @override
  Future<Result<void>> register(String email, String firstName, String lastName,
      String phoneNumber, String password, String confirmPassword) async {
    final res = await _onlineDataSource.register(
        email, firstName, lastName, phoneNumber, password, confirmPassword);
    return res is Success ? Success(res.data) : Fail((res as Fail).exception);
  }

  @override
  Future<void> checkCache() async {
    if (_providerContainer.read(userProvider.notifier).token == null) {
      final user = await _offlineDataSource.getUserFromToken();
      final token = _offlineDataSource.getToken();
      if (token != null && user != null) {
        _providerContainer.read(userProvider.notifier).setUser(user, token);
        platform.invokeMethod('isBackgroundServiceRunning').then((value) {
          if (value == false) {
            platform.invokeMethod('startBackgroundService', {'token': token});
          }
        });
      }
    }
  }

  @override
  Future<void> logout() async {
    await _offlineDataSource.clearToken();
    _providerContainer.read(userProvider.notifier).clearUser();
    //platform.invokeMethod('stopBackgroundService');
  }
}
