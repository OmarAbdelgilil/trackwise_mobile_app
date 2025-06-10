// import 'package:elevate_ecommerce/features/auth/forget_password/presentation/forget_password_validator/forget_password_validator_types_enum.dart';
// import 'package:elevate_ecommerce/utils/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

@injectable
class ForgetPasswordValidator {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;

  GlobalKey<FormState> get emailFormKey => _emailFormKey;
  GlobalKey<FormState> get otpFormKey => _otpFormKey;
  GlobalKey<FormState> get passwordFormKey => _passwordFormKey;

  void disposeFields() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  String? Function(String?) validate(ForgetPasswordValidTypes type) {
    switch (type) {
      case ForgetPasswordValidTypes.email:
        return _validateEmail();
      case ForgetPasswordValidTypes.password:
        return _validatePassword();
      case ForgetPasswordValidTypes.confirmPassword:
        return _validateConfirmPassword();
      case ForgetPasswordValidTypes.otp:
        return (String? value) {
          return null;
        };
    }
  }

  String? Function(String?) _validateEmail() {
    return (String? value) {
      if (value != null && (value.isEmpty || !value.contains("@"))) {
        return StringsManager.issueValidEmail;
      }
      return null;
    };
  }

  String? Function(String?) _validatePassword() {
    return (String? value) {
      final RegExp passwordRegExp = RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$');
      if (value == null || value.isEmpty) {
        return StringsManager.issueEmptyPassword;
      } else if (!passwordRegExp.hasMatch(value)) {
        return StringsManager.issuePasswordPattern;
      }
      return null;
    };
  }

  String? Function(String?) _validateConfirmPassword() {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return StringsManager.issueEmptyPassword;
      }
      if (_passwordController.text != value) {
        return StringsManager.issuePasswordNotMatch;
      }
      return null;
    };
  }
}

enum ForgetPasswordValidTypes { email, password, confirmPassword, otp }
