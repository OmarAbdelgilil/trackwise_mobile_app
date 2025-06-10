import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Function()? onPressed;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? borderRadius;
  final Color? backgroundColor;
  final Widget text;
  final TextStyle? textStyle;
  const AppButton(
      {super.key,
      this.onPressed,
      this.verticalPadding,
      this.horizontalPadding,
      this.borderRadius,
      this.backgroundColor,
      required this.text,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.blue,
          ),
          onPressed: onPressed,
          child: text),
    );
  }
}
