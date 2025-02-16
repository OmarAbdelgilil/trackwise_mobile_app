import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';
import 'package:track_wise_mobile_app/utils/image_path_manager.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

class ScaffoldAppBar extends StatelessWidget implements PreferredSizeWidget{
  const ScaffoldAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            ImagePathManager.heartBeat,
            fit: BoxFit.contain,
            width: 20.w,
          ),
          SizedBox(
            width: 7.w,
          ),
          Text(
            StringsManager.homeScreenTitle,
            style: TextStyle(fontSize: 24.sp, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: ColorsManager.backgroundColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        )
      ],
    );
  }
}
