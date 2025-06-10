import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

class ResetSuccessfullyScreen extends StatelessWidget {
  final BuildContext mainContext;
  const ResetSuccessfullyScreen({super.key, required this.mainContext});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(mainContext).pop();
    });
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset("assets/lotties/success.json"),
              SizedBox(
                height: 5.h,
              ),
              Text(
                StringsManager.passwordResetSuccess,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
