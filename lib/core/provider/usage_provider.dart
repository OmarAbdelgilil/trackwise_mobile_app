import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';

class AppUsageNotifier extends StateNotifier<Map<String, List<AppUsageData>>> {
  static const platform = MethodChannel('usage_stats');

  AppUsageNotifier() : super({});

  Future<void> checkPermissions() async {
    final permission = await platform.invokeMethod('checkUsageAccess');
    if (!permission) {
      await platform.invokeMethod('openUsageAccessSettings');
    }
  }

  Future<List<AppUsageData>> getUsageData(
      DateTime startDate, DateTime endDate) async {
    final String formattedDate =
        "${startDate.toString()};;;${endDate.toString()}";
    if (state.containsKey(formattedDate)) {
      return state[formattedDate]!;
    }
    try {
      late List<Map<dynamic, dynamic>>? appsUsage;
      appsUsage = await platform.invokeListMethod('getUsageStats', {
        "startTime": startDate.millisecondsSinceEpoch,
        "endTime": endDate.millisecondsSinceEpoch,
      });
      List<AppUsageData> infoList = [];
      if (appsUsage != null && appsUsage.isNotEmpty) {
        infoList = appsUsage.map((e) => AppUsageData.fromJson(e)).where((element) => element.usageTime.inMinutes != 0).toList();
      }

      state = {...state, formattedDate: infoList};
      return infoList;
    } catch (e) {
      rethrow;
    }
  }
}

final appUsageProvider =
    StateNotifierProvider<AppUsageNotifier, Map<String, List<AppUsageData>>>(
        (ref) => AppUsageNotifier());
