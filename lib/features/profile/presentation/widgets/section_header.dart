import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback onPressed;
  const SectionHeader(
      {super.key,
      required this.title,
      required this.buttonText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        const Spacer(),
        TextButton(
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.primaryColor),
          ),
        ),
      ],
    );
  }
}
