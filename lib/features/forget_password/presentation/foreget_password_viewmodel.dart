// import 'package:elevate_ecommerce/core/common/api_result.dart';
// import 'package:elevate_ecommerce/features/auth/domain/model/user.dart';
// import 'package:elevate_ecommerce/features/auth/forget_password/data/models/requests/forgot_password_request.dart';
// import 'package:elevate_ecommerce/features/auth/forget_password/data/models/requests/reset_password_request.dart';
// import 'package:elevate_ecommerce/features/auth/forget_password/data/models/requests/verify_password_request.dart';
// import 'package:elevate_ecommerce/features/auth/forget_password/data/models/responses/forgot_password_response.dart';
// import 'package:elevate_ecommerce/features/auth/forget_password/data/models/responses/verify_password_response.dart';
// import 'package:elevate_ecommerce/features/auth/forget_password/domain/usecases/forget_password_usecase.dart';
// import 'package:elevate_ecommerce/features/auth/forget_password/presentation/forget_password_validator/forget_password_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/forget_password/data/contracts/forget_password_online_datasource.dart';
import 'package:track_wise_mobile_app/features/forget_password/data/models/responses/password_reset_response.dart';
import 'package:track_wise_mobile_app/features/forget_password/data/models/responses/verify_email_response.dart';
import 'package:track_wise_mobile_app/features/forget_password/data/models/responses/verify_otp_response.dart';
import 'package:track_wise_mobile_app/features/forget_password/presentation/forget_password_validator/forget_password_validator.dart';

@injectable
class ForegetPasswordViewmodel extends Cubit<ForgetPasswordState> {
  // ForgetPasswordUsecase forgetPasswordUsecase;
  ForgetPasswordValidator forgetPasswordValidator;
  final ForgetPasswordOnlineDatasource _forgetPasswordOnlineDatasource;
  String emailToken = "";
  String otpToken = "";
  ForegetPasswordViewmodel(
      this.forgetPasswordValidator, this._forgetPasswordOnlineDatasource)
      : super(InitialState(null));

  void doIntent(ForgetPasswordScreenIntent intent) {
    switch (intent) {
      case VerifyEmailIntent():
        {
          _checkEmail(intent);
        }
      case VerifyOtpIntent():
        {
          _verifyOtp(intent);
        }
      case ResetPasswordIntent():
        {
          _resetPassword(intent);
        }
    }
  }
  // }

  Future<void> _checkEmail(VerifyEmailIntent intent) async {
    emit(LoadingState());
    if (!forgetPasswordValidator.emailFormKey.currentState!.validate()) {
      emit(InitialState(null));
      return;
    }

    var result =
        await _forgetPasswordOnlineDatasource.verifyEmail(intent.email);
    switch (result) {
      case Success<VerifyEmailResponse>():
        emailToken = result.data!.token!;
        emit(VerifyOtpState(intent.email, null));
      case Fail<VerifyEmailResponse>():
        emit(InitialState(result.exception));
    }
  }

  Future<void> _verifyOtp(VerifyOtpIntent intent) async {
    emit(LoadingState());
    var result =
        await _forgetPasswordOnlineDatasource.verifyOtp(intent.otp, emailToken);
    switch (result) {
      case Success<VerifyOtpResponse>():
        otpToken = result.data!.resetToken!;
        emit(ResetPasswordState(null));
      case Fail<VerifyOtpResponse>():
        emit(VerifyOtpState(intent.email, result.exception));
    }
  }

  Future<void> _resetPassword(ResetPasswordIntent intent) async {
    emit(LoadingState());
    if (!forgetPasswordValidator.passwordFormKey.currentState!.validate()) {
      emit(ResetPasswordState(null));
      return;
    }
    var result = await _forgetPasswordOnlineDatasource.resetPass(
        intent.newPassword, intent.newPassword, otpToken);
    switch (result) {
      case Success<PasswordResetResponse>():
        {
          forgetPasswordValidator.disposeFields();
          emit(SuccessState());
        }
      case Fail<PasswordResetResponse>():
        {
          emit(ResetPasswordState(result.exception));
        }
    }
  }
}

sealed class ForgetPasswordScreenIntent {}

class VerifyEmailIntent extends ForgetPasswordScreenIntent {
  String email;
  VerifyEmailIntent(this.email);
}

class VerifyOtpIntent extends ForgetPasswordScreenIntent {
  String email;
  String otp;
  VerifyOtpIntent(this.email, this.otp);
}

class ResetPasswordIntent extends ForgetPasswordScreenIntent {
  String newPassword;
  ResetPasswordIntent(this.newPassword);
}

sealed class ForgetPasswordState {}

class InitialState extends ForgetPasswordState {
  Exception? error;
  InitialState(this.error);
}

class LoadingState extends ForgetPasswordState {}

class VerifyOtpState extends ForgetPasswordState {
  String? email;
  Exception? error;
  VerifyOtpState(this.email, this.error);
}

class ResetPasswordState extends ForgetPasswordState {
  Exception? error;
  ResetPasswordState(this.error);
}

class SuccessState extends ForgetPasswordState {
  SuccessState();
}
