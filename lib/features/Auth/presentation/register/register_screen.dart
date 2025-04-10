import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/Auth/presentation/login/login_screen.dart';
import 'package:track_wise_mobile_app/features/Auth/presentation/register/register_viewmodel.dart';
import 'package:track_wise_mobile_app/main.dart';
import 'package:track_wise_mobile_app/utils/custom_text_field.dart';
import 'package:track_wise_mobile_app/utils/extract_error.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  RegExp emailRegex =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regProv = ref.watch(registerProvider);

    if (regProv is RegSuccessState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        ref.read(registerProvider.notifier).resetState();
      });
    }
    if (regProv is RegErrorState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scaffoldMessengerKey.currentState!.clearSnackBars();
        scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text(extractErrorMessage(regProv.error))),
        );
        ref.read(registerProvider.notifier).resetState();
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringsManager.signUpTitle,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _firstNameController,
                              label: StringsManager.firstNameLabel,
                              hint: StringsManager.firstNameHint,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return StringsManager.emptyEmailError;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: CustomTextField(
                              controller: _lastNameController,
                              label: StringsManager.lastNameLabel,
                              hint: StringsManager.lastNameHint,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return StringsManager.emptyEmailError;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
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
                          } else if (value.length < 8) {
                            return StringsManager.minLengthPasswordError;
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        label: StringsManager.confirmPasswordLabel,
                        hint: StringsManager.passwordHint,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return StringsManager.passwordDontMatchError;
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: _confirmPasswordController,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        label: StringsManager.phoneNumberLabel,
                        hint: StringsManager.phoneNumberHint,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !RegExp(r'^\d{11}$').hasMatch(value)) {
                            return StringsManager.phoneNumberError;
                          }
                          return null;
                        },
                        controller: _phoneNumberController,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  )),
              regProv is RegLoadingState?
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
                              ref.read(registerProvider.notifier).register(
                                  _emailController.text,
                                  _firstNameController.text,
                                  _lastNameController.text,
                                  _phoneNumberController.text,
                                  _passwordController.text,
                                  _confirmPasswordController.text);
                            }
                          },
                          child: Text(
                            StringsManager.register,
                            style: TextStyle(fontSize: 16.sp),
                          )),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    StringsManager.alreadyHaveAcc,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      StringsManager.signIn,
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
