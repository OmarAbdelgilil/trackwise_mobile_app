import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_wise_mobile_app/features/Auth/data/contracts/offline_data_source.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';

@Injectable(as: OfflineDataSource)
class OfflineDataSourceImpl implements OfflineDataSource {
  final SharedPreferences _prefs;
  OfflineDataSourceImpl(this._prefs);
  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString("token", token);
  }

  @override
  String? getToken() {
    return _prefs.getString("token");
  }

  @override
  Future<bool> clearToken() async {
    return await _prefs.remove("token");
  }

  @override
  Future<User?> getUserFromToken() async {
    final token = getToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      final decodedToken = JwtDecoder.decode(token);
      return User.fromJson(decodedToken);
    }
    return null;
  }
}
