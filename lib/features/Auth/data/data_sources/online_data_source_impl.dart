import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/api/api_execution.dart';
import 'package:track_wise_mobile_app/core/api/api_manager.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/Auth/data/contracts/online_data_source.dart';
import 'package:track_wise_mobile_app/features/Auth/data/models/request/login_request.dart';
import 'package:track_wise_mobile_app/features/Auth/data/models/request/register_request.dart';
import 'package:track_wise_mobile_app/features/Auth/data/models/response/login_response.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';

@Injectable(as: OnlineDataSource)
class OnlineDataSourceImpl implements OnlineDataSource {
  final ApiManager _apiManager;
  OnlineDataSourceImpl(this._apiManager);

  @override
  Future<Result<LoginResponse>> login(String email, String password) async{
    return await executeApi(() async {
      final loginRequest = LoginRequest(email: email, password: password);
      final result = await _apiManager.login(loginRequest);
      return result;
    });
  }
  @override
   void setUsageHistory(Map<DateTime, List<AppUsageData>> usageData, String token)
   {
    executeApi(() async {
      _apiManager.setUsageHistory(usageData, token);
    });
   }
   @override
   void setStepsHistory(Map<String, int> stepsData, String token)
   {
    executeApi(() async {
      _apiManager.setStepsHistory(stepsData, token);
    });
   }

  @override
  Future<Result<void>> register(String email, String firstName, String lastName, String phoneNumber, String password, String confirmPassword) async {
    return executeApi(() async {
      final registerRequest = RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      await _apiManager.register(registerRequest);
      return;
    });
  }
}
