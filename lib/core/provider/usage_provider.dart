import 'package:app_usage/app_usage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AppUsageNotifier extends StateNotifier<Map<String, List<AppUsageInfo>>> {
  static const platform = MethodChannel('usage_stats');

  AppUsageNotifier() : super({});

  Future<List<AppUsageInfo>> getUsageData(
      DateTime startDate, DateTime endDate) async {
    late List<Map<dynamic, dynamic>>? appsUsage;

    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.manufacturer == 'samsung') {
      appsUsage = await platform.invokeListMethod('getUsageStatsSam', {
        "startTime": startDate.millisecondsSinceEpoch,
        "endTime": endDate.millisecondsSinceEpoch,
      });
    } else {
      appsUsage = await platform.invokeListMethod('getUsageStats', {
        "startTime": startDate.millisecondsSinceEpoch,
        "endTime": endDate.millisecondsSinceEpoch,
      });
    }
    print(appsUsage![2]);

    final String formattedDate =
        "${startDate.toString()};;;${endDate.toString()}";
    if (state.containsKey(formattedDate)) {
      return state[formattedDate]!;
    }
    try {
      //List<AppInfo>? appNames = await AppCheck().getInstalledApps();
      List<AppUsageInfo> infoList = [];
      List<AppUsageInfo> infoListTemp =
          await AppUsage().getAppUsage(startDate, endDate);
      // for (AppInfo i in appNames!) {
      //   // if (i.isSystemApp == null || i.isSystemApp == true) continue;
      //   try {
      //     infoList.add(infoListTemp
      //         .firstWhere((element) => element.packageName == i.packageName));
      //   } catch (e) {}
      // }
      for (AppUsageInfo i in infoListTemp) {
        print(i.appName);
        print(i.usage.inMinutes);
      }

      state = {...state, formattedDate: infoList};
      return infoList;
    } catch (e) {
      rethrow;
    }
  }
}

final appUsageProvider =
    StateNotifierProvider<AppUsageNotifier, Map<String, List<AppUsageInfo>>>(
        (ref) => AppUsageNotifier());
