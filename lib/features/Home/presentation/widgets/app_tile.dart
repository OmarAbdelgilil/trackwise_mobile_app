import 'package:flutter/material.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';
import 'package:track_wise_mobile_app/utils/image_path_manager.dart';

class AppTile extends StatelessWidget {
  const AppTile({super.key,required this.appData,required this.maxUsage});
  final AppUsageData appData;
  final Duration maxUsage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
              leading: appData.appIcon.isEmpty? Image.asset(ImagePathManager.appIcon, scale: 12) : CircleAvatar(
                backgroundColor: Colors.white,
                child:  Image.memory(appData.appIcon), 
              ),
              title: Text(
                appData.appName,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    //number of hours / max number of hours in this day
                    value: appData.usageTime.inMinutes / maxUsage.inMinutes,
                    backgroundColor: Colors.grey.shade800,//Color.fromARGB(0, 66, 66, 66), 
                    valueColor:const AlwaysStoppedAnimation<Color>(ColorsManager.blue),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      appData.usageTime.inHours != 0 ?'${appData.usageTime.inHours}hrs' : '${appData.usageTime.inMinutes}mins',
                      style:const TextStyle(color: Colors.white70),
                    ),
                  )
                ],
              ),
            );
  }
}