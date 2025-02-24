import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';

abstract class OfflineDataSource {
  Future<void> saveToken(String token);
  String? getToken();
  Future<bool> clearToken();
  Future<User?> getUserFromToken();
}
