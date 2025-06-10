import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/forget_password/data/models/responses/password_reset_response.dart';
import 'package:track_wise_mobile_app/features/forget_password/data/models/responses/verify_email_response.dart';
import 'package:track_wise_mobile_app/features/forget_password/data/models/responses/verify_otp_response.dart';

abstract class ForgetPasswordOnlineDatasource {
  Future<Result<VerifyEmailResponse>> verifyEmail(String email);
  Future<Result<VerifyOtpResponse>> verifyOtp(String otp, String token);
  Future<Result<PasswordResetResponse>> resetPass(
      String pass, String confirmPass, String token);
}
