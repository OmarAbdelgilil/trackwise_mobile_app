import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/nav_bar_router/app_router.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/nav_bar_router/nav_bar_router.dart';
import 'package:track_wise_mobile_app/features/Notifications/presentation/notifications_screen.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';
import 'package:track_wise_mobile_app/utils/image_path_manager.dart';

class ScaffoldAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ScaffoldAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  Widget _getIcon(String currentPage) {
    switch (currentPage) {
      case AppRoutes.homeScreen:
        return Image.asset(
          ImagePathManager.heartBeat,
          fit: BoxFit.contain,
          width: 22.w,
        );
      case AppRoutes.steps:
        return const Icon(
          Icons.directions_walk,
          size: 22,
          color: ColorsManager.blue,
        );
      case AppRoutes.friends:
        return const Icon(Icons.people_alt_outlined,
            size: 22, color: ColorsManager.blue);
      case AppRoutes.profile:
        return const Icon(Icons.person_outline,
            size: 22, color: ColorsManager.blue);
      default:
        return const Icon(Icons.person_outline,
            size: 22, color: ColorsManager.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: currentPageNotifier,
        builder: (context, value, child) {
          final Widget icon = _getIcon(value['currentPage']);
          return AppBar(
            title: Row(
              children: [
                icon,
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  value['currentPage'],
                  style: TextStyle(fontSize: 24.sp),
                ),
              ],
            ),
            actions: [
              Stack(children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ));
                  },
                ),
                const Positioned(
                    right: 14,
                    top: 14,
                    child: Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 10,
                    ))
              ])
            ],
          );
        });
  }
}
