import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/api/api_execution.dart';
import 'package:track_wise_mobile_app/core/api/api_manager.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/Auth/data/contracts/online_data_source.dart';
import 'package:track_wise_mobile_app/features/Auth/data/models/request/login_request.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

@Injectable(as: OnlineDataSource)
class OnlineDataSourceImpl implements OnlineDataSource {
  final ApiManager _apiManager;
  OnlineDataSourceImpl(this._apiManager);

  @override
  Future<Result<User>> login(String eamil, String password) {
    return executeApi(() async {
      final loginRequest = LoginRequest(email: eamil, password: password);
      final result = await _apiManager.login(loginRequest);
      final decodedToken = JwtDecoder.decode(result.token!);
      return User.fromJson(decodedToken);
    });
  }
}
