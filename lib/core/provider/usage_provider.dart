import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';

class AppUsageNotifier extends StateNotifier<Map<String, List<AppUsageData>>> {
  static const platform = MethodChannel('usage_stats');

  AppUsageNotifier() : super({});
  void printLongString(String text) {
    const int chunkSize = 1000; // Adjust as needed
    for (int i = 0; i < text.length; i += chunkSize) {
      print(text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize));
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
        infoList = appsUsage.map((e) => AppUsageData.fromJson(e)).toList();
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
