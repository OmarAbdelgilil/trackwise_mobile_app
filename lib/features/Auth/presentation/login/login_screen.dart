import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/Auth/presentation/login/login_viewmodel.dart';
import 'package:track_wise_mobile_app/features/Auth/presentation/register/register_screen.dart';
import 'package:track_wise_mobile_app/features/forget_password/presentation/forget_password_screen.dart';
import 'package:track_wise_mobile_app/main.dart';
import 'package:track_wise_mobile_app/utils/custom_text_field.dart';
import 'package:track_wise_mobile_app/utils/extract_error.dart';

import 'package:track_wise_mobile_app/utils/strings_manager.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  RegExp emailRegex =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logProv = ref.watch(loginProvider);

    if (logProv is SuccessState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
        ref.read(loginProvider.notifier).resetState();
      });
    }
    if (logProv is ErrorState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scaffoldMessengerKey.currentState!.clearSnackBars();
        scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text(extractErrorMessage(logProv.error))),
        );
        ref.read(loginProvider.notifier).resetState();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringsManager.loginTitle,
          style: TextStyle(fontSize: 24.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        label: StringsManager.emailLabel,
                        hint: StringsManager.emailHint,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return StringsManager.emptyEmailError;
                          }
                          if (!emailRegex.hasMatch(value)) {
                            return StringsManager.invalidEmailFormat;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        label: StringsManager.passwordLabel,
                        hint: StringsManager.passwordHint,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return StringsManager.emptyPasswordError;
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: _passwordController,
                      ),
                    ],
                  )),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgetPasswordScreen(),
                    ));
                  },
                  child: Text(
                    StringsManager.forgetPassBtn,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              logProv is LoadingState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: 281.w,
                      height: 50.h,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              ref.read(loginProvider.notifier).login(
                                  _emailController.text,
                                  _passwordController.text);
                            }
                          },
                          child: Text(
                            StringsManager.loginTitle,
                            style: TextStyle(fontSize: 16.sp),
                          )),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    StringsManager.dontHaveAcc,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: Text(
                      StringsManager.signUp,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
