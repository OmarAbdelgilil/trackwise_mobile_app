import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/features/forget_password/presentation/foreget_password_viewmodel.dart';
import 'package:track_wise_mobile_app/features/forget_password/presentation/forget_password_validator/forget_password_validator.dart';
import 'package:track_wise_mobile_app/features/forget_password/presentation/reset_successfully_screen.dart';
import 'package:track_wise_mobile_app/features/forget_password/presentation/verify_email.dart';
import 'package:track_wise_mobile_app/features/forget_password/presentation/verify_otp.dart';
import 'package:track_wise_mobile_app/features/forget_password/presentation/verify_password.dart';

// ignore: must_be_immutable
class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  ForegetPasswordViewmodel viewModel = getIt.get<ForegetPasswordViewmodel>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController =
        viewModel.forgetPasswordValidator.emailController;
    final emailValidator = viewModel.forgetPasswordValidator
        .validate(ForgetPasswordValidTypes.email);
    final emailFormKey = viewModel.forgetPasswordValidator.emailFormKey;
    final passwordFormkey = viewModel.forgetPasswordValidator.passwordFormKey;
    final passwordcontroller =
        viewModel.forgetPasswordValidator.passwordController;
    final confirmPasswordController =
        viewModel.forgetPasswordValidator.confirmPasswordController;
    final passwordValidator = viewModel.forgetPasswordValidator
        .validate(ForgetPasswordValidTypes.password);
    final confirmPasswordValidator = viewModel.forgetPasswordValidator
        .validate(ForgetPasswordValidTypes.confirmPassword);

    return BlocProvider(
      create: (context) => viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Forget Password"),
        ),
        body: BlocBuilder<ForegetPasswordViewmodel, ForgetPasswordState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is VerifyOtpState) {
              return Center(
                child: VerifyOtp(
                  emailController: emailController,
                  sendOtp: sendOtp,
                  verifyOtp: verifyOtp,
                  exception: state.error,
                ),
              );
            }
            if (state is ResetPasswordState) {
              return VerifyPassword(
                passwordFormKey: passwordFormkey,
                passwordController: passwordcontroller,
                confirmPasswordController: confirmPasswordController,
                passwordValidator: passwordValidator,
                confirmPasswordValidator: confirmPasswordValidator,
                resetPassword: resetPassword,
                exception: state.error,
              );
            }
            if (state is InitialState) {
              return Center(
                  child: VerifyEmail(
                formKey: emailFormKey,
                emailValidator: emailValidator,
                emailController: emailController,
                sendOtp: sendOtp,
                exception: state.error,
              ));
            }
            if (state is SuccessState) {
              return ResetSuccessfullyScreen(
                mainContext: context,
              );
            }
            return Center(
                child: VerifyEmail(
              formKey: emailFormKey,
              emailValidator: emailValidator,
              emailController: emailController,
              sendOtp: sendOtp,
            ));
          },
        ),
      ),
    );
  }

  void sendOtp(String email) {
    viewModel.doIntent(VerifyEmailIntent(email));
  }

  void verifyOtp(String email, String otp) {
    viewModel.doIntent(VerifyOtpIntent(email, otp));
  }

  void resetPassword(String newPassword) {
    viewModel.doIntent(ResetPasswordIntent(newPassword));
  }
}
