import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/profile/presentation/widgets/section_header.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class ProfileDetailsSection extends StatelessWidget {
  final String email;
  final String phone;
  const ProfileDetailsSection(
      {super.key, required this.email, required this.phone});
  Widget detailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: ColorsManager.lightgrey,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
            title: "Personal Info", buttonText: "Edit", onPressed: () {}),
        detailItem("Email", email),
        detailItem("Phone", phone),
      ],
    );
  }
}
