// import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/core/local/hive_manager.dart';
import 'package:track_wise_mobile_app/core/provider/usage_provider.dart';
import 'package:track_wise_mobile_app/core/provider/user_provider.dart';
import 'package:track_wise_mobile_app/features/Auth/data/contracts/offline_data_source.dart';
import 'package:track_wise_mobile_app/features/Auth/data/contracts/online_data_source.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/repos/auth_repository.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';
// import 'package:track_wise_mobile_app/features/Home/presentation/home_view_model.dart';
import 'package:track_wise_mobile_app/main.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final OnlineDataSource _onlineDataSource;
  final OfflineDataSource _offlineDataSource;
  final ProviderContainer _providerContainer = providerContainer;
  final HiveManager _hiveManager;
  static const platform = MethodChannel('usage_stats');
  AuthRepositoryImpl(
      this._onlineDataSource, this._offlineDataSource, this._hiveManager);

  @override
  Future<Result<User>> login(String email, String password) async {
    final Result<String> result =
        await _onlineDataSource.login(email, password);

    if (result is Success<String> && result.data != null) {
      final token = result.data!;
      final decodedToken = JwtDecoder.decode(token);
      final user = User.fromJson(decodedToken);
      _providerContainer.read(userProvider.notifier).setUser(user, token);
      await _offlineDataSource.saveToken(token);
      try {
        if (!decodedToken.containsKey('usage') ||
            decodedToken['usage'] == null ||
            (decodedToken['usage'] as Map<String, dynamic>).isEmpty) {
          _onlineDataSource.setUsageHistory(
              _providerContainer.read(appUsageProvider), token);
        } else {
          final data = await AppUsageData.fromRequest(decodedToken['usage']);
          await _hiveManager.clearUsageCache();
          await _hiveManager.addAllUsageToCache(data);
          _providerContainer.read(appUsageProvider.notifier).resetUsageProvider(data);
          //_providerContainer.read(homeProvider.notifier).resetUsageWhenLogin();

        }
      } catch (e) {
        print(e);
      }
      platform.invokeMethod('startBackgroundService', {'token': token});
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
    await _hiveManager.clearUsageCache();
    platform.invokeMethod('stopBackgroundService');
  }
}
