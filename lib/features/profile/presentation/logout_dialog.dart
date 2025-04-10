import 'package:flutter/material.dart';

void showLogoutDialog(
    BuildContext context, Future<void> Function() logoutFunction) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          "Logout",
        ),
        content: const Text(
          "Are you sure you want to log out?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
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
