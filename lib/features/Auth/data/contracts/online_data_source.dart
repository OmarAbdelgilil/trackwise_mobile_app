import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/Auth/data/models/response/login_response.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';

abstract class OnlineDataSource {
  Future<Result<LoginResponse>> login(String eamil, String password);
  Future<Result<void>> register(String email, String firstName, String lastName,String phoneNumber, String password, String confirmPassword);
  void setUsageHistory(Map<DateTime, List<AppUsageData>> usageData, String token);
}
