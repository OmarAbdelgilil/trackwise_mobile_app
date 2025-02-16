import 'package:flutter/material.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/home_screen.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/nav_bar_router/app_router.dart';
import 'package:track_wise_mobile_app/features/friends/presentation/friends_screen.dart';
import 'package:track_wise_mobile_app/features/profile/presentation/friends_screen.dart';
import 'package:track_wise_mobile_app/features/steps/presentation/steps_screen.dart';

class CurrentPageNotifier extends ValueNotifier<Map<String,dynamic>> {
  CurrentPageNotifier() : super({"currentPage": "home", "widget": const HomeScreen()});
  void setPage(String currentPage) {
    Widget widget;
    switch (currentPage) {
      case AppRoutes.homeScreen:
        widget = const HomeScreen();
        break;
      case AppRoutes.steps:
        widget = const StepsScreen();
        break;
      case AppRoutes.friends:
        widget = const FriendsScreen();
        break;
      case AppRoutes.profile:
        widget = const ProfileScreen();
        break;
      default:
        widget = const HomeScreen();
        break;
    }
    value = {"currentPage": currentPage, "widget": widget};
  }
}

final currentPageNotifier = CurrentPageNotifier();