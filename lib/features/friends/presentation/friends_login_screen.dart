import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/Auth/presentation/login/login_screen.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class FriendsLoginScreen extends StatelessWidget {
  const FriendsLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.people_alt_outlined,
              size: 250.sp,
              color: const Color.fromARGB(143, 73, 69, 79),
            ),
            Transform.translate(
              offset: Offset(0, -35.h),
              child: Text(
                'Login',
                style:
                    TextStyle(fontSize: 40.sp, color: ColorsManager.darkGrey),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -35.h),
              child: Text(
                'Login to show your friends',
                style:
                    TextStyle(fontSize: 20.sp, color: ColorsManager.darkGrey),
              ),
            ),
            SizedBox(
              width: 180,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.darkTr,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Login", style: TextStyle(fontSize: 18.sp))),
            )
          ],
        ),
      ),
    );
  }
}
