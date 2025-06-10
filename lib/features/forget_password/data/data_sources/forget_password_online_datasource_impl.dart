import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/api/api_execution.dart';
import 'package:track_wise_mobile_app/core/api/api_manager.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/forget_password/data/contracts/forget_password_online_datasource.dart';
import 'package:track_wise_mobile_app/features/forget_password/data/models/responses/password_reset_response.dart';
import 'package:track_wise_mobile_app/features/forget_password/data/models/responses/verify_email_response.dart';
import 'package:track_wise_mobile_app/features/forget_password/data/models/responses/verify_otp_response.dart';

@Injectable(as: ForgetPasswordOnlineDatasource)
class ForgetPasswordOnlineDatasourceImpl
    implements ForgetPasswordOnlineDatasource {
  final ApiManager apiManager;
  ForgetPasswordOnlineDatasourceImpl(this.apiManager);

  @override
  Future<Result<VerifyEmailResponse>> verifyEmail(String email) {
    return executeApi(
      () async {
        return await apiManager.verifyEmail(email);
      },
    );
  }

  @override
  Future<Result<VerifyOtpResponse>> verifyOtp(String otp, String token) {
    return executeApi(
      () async {
        return await apiManager.verifyOtp(otp, token);
      },
    );
  }

  @override
  Future<Result<PasswordResetResponse>> resetPass(
      String pass, String confirmPass, String token) {
    return executeApi(
      () async {
        return await apiManager.resetPass(pass, confirmPass, token);
      },
    );
  }
}
