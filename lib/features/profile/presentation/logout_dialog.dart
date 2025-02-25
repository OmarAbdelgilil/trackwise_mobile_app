import 'package:flutter/material.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

void showLogoutDialog(
    BuildContext context, Future<void> Function() logoutFunction) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: ColorsManager.backgroundColor,
        title: const Text(
          "Logout",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text("Are you sure you want to log out?",
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await logoutFunction();
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
