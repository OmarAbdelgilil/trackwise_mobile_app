import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

class VerifyOtp extends StatelessWidget {
  final Exception? exception;
  final Function(String email) sendOtp;
  final Function(String email, String otp) verifyOtp;
  final TextEditingController emailController;
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  VerifyOtp(
      {super.key,
      required this.emailController,
      required this.sendOtp,
      required this.verifyOtp,
      this.exception});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              StringsManager.verifyOtpScreenTitle,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
                textAlign: TextAlign.center,
                StringsManager.verifyOtpScreenGuide,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp)),
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 60.w,
                  height: 80.h,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(context)
                              .requestFocus(_focusNodes[index + 1]);
                        }
                        if (index == 3 && value.isNotEmpty) {
                          final otp = _controllers
                              .map((controller) => controller.text)
                              .join();
                          verifyOtp(emailController.text, otp);
                        }
                      },
                      decoration: InputDecoration(
                          errorText: exception != null ? '' : null,
                          counterText: "",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                );
              }),
            ),
            if (exception != null) ...[
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 16.sp,
                    ),
                    const Text(StringsManager.invalidOtpError,
                        style: TextStyle(
                          color: Colors.red,
                        ))
                  ],
                ),
              )
            ],
            SizedBox(
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }
}
