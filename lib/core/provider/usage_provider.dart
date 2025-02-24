import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';

class AppUsageNotifier extends StateNotifier<Map<DateTime, List<AppUsageData>>> {
  static const platform = MethodChannel('usage_stats');

  AppUsageNotifier() : super({});

  Future<List<AppUsageData>> getUsageData(
      DateTime startDate, DateTime endDate) async {
    if (state.containsKey(startDate)) {
      return state[startDate]!;
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

      state = {...state, startDate: infoList};
      return infoList;
    } catch (e) {
      rethrow;
    }
  }

  List<AppUsageData>? getUsageState(DateTime date)
  {
    //check cache here
    return state[date];
  }
}

final appUsageProvider =
    StateNotifierProvider<AppUsageNotifier, Map<DateTime, List<AppUsageData>>>(
        (ref) => AppUsageNotifier());
