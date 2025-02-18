import 'package:app_usage/app_usage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppUsageNotifier extends StateNotifier<Map<String, List<AppUsageInfo>>> {
  AppUsageNotifier() : super({});

  Future<List<AppUsageInfo>> getUsageData(
      DateTime startDate, DateTime endDate) async {
    final String formattedDate =
        "${startDate.toString()};;;${endDate.toString()}";
    if (state.containsKey(formattedDate)) {
      return state[formattedDate]!;
    }
    try {
      List<AppInfo> appNames = await InstalledApps.getInstalledApps(true, true);
      List<AppUsageInfo> infoList = [];
      List<AppUsageInfo> infoListTemp =
          await AppUsage().getAppUsage(startDate, endDate);
      for (AppInfo i in appNames) {
        infoList.add(infoListTemp.firstWhere(
          (element) => element.appName == i.name,
        ));
      }
      for (AppUsageInfo i in infoList) {
        print(i.appName);
        print(i.usage.inHours);
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
