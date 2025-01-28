import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/api/api_constants.dart';
import 'package:track_wise_mobile_app/features/Auth/data/models/request/login_request.dart';
import 'package:track_wise_mobile_app/features/Auth/data/models/response/login_response.dart';

@singleton
@injectable
class ApiManager {
  late Dio _dio;
  ApiManager() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
    ));
  }

  Future<LoginResponse> login(LoginRequest request) async {
    var response =
        await _dio.post(ApiConstants.loginPath, data: request.toJson());
    var authResponse = LoginResponse.fromJson(response.data);
    return authResponse;
  }
}
