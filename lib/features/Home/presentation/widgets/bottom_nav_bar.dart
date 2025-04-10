import 'package:flutter/material.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/nav_bar_router/app_router.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/nav_bar_router/nav_bar_router.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';
import 'package:track_wise_mobile_app/utils/image_path_manager.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        switch (index) {
          case 0:
            currentPageNotifier.setPage(AppRoutes.homeScreen);
            break;
          case 1:
            currentPageNotifier.setPage(AppRoutes.steps);
            break;
          case 2:
            //todo
            currentPageNotifier.setPage(AppRoutes.friends);
            break;
          case 3:
            //todo
            currentPageNotifier.setPage(AppRoutes.profile);
            break;
          default:
            currentPageNotifier.setPage(AppRoutes.homeScreen);
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: ColorsManager.blue,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      iconSize: 22,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(ImagePathManager.heartBeat, scale: 1.7),
          label: StringsManager.usage,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.directions_walk, size: 22),
          label: StringsManager.steps,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_outlined, size: 22),
          label: StringsManager.friends,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, size: 22),
          label: StringsManager.profile,
        ),
      ],
    );
  }
}
