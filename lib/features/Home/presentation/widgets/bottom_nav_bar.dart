import 'package:flutter/material.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';
import 'package:track_wise_mobile_app/utils/image_path_manager.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  backgroundColor: Colors.black,
  currentIndex: 0, 
  onTap: (value) {}, 
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