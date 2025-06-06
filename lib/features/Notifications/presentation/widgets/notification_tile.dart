import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationTile extends StatelessWidget {
  final String appName;
  final String packageName;
  const NotificationTile(
      {super.key, required this.appName, required this.packageName});

  @override
  Widget build(BuildContext context) {
    void openAppInPlayStore(String packageName) async {
      final Uri playStoreUrl = Uri.parse(
          "https://play.google.com/store/apps/details?id=$packageName");

      if (await canLaunchUrl(playStoreUrl)) {
        await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $playStoreUrl';
      }
    }

    return InkWell(
      onTap: () => openAppInPlayStore(packageName),
      child: ListTile(
        title: const Text(
          "YOU MAY ALSO LIKE TO TRY",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(appName),
        trailing: const Text("Tap to view in play store"),
      ),
    );
  }
}
