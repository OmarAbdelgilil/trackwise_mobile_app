import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/core/local/execute_hive.dart';
import 'package:track_wise_mobile_app/core/local/hive_manager.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';
@injectable
class AppUsageNotifier
    extends StateNotifier<Map<DateTime, List<AppUsageData>>> {
  static const platform = MethodChannel('usage_stats');
  final HiveManager _hiveManager;
  AppUsageNotifier(this._hiveManager) : super({});

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
        infoList = appsUsage
            .map((e) => AppUsageData.fromJson(e))
            .where((element) => element.usageTime.inMinutes != 0)
            .toList();
      }
      if (infoList.isNotEmpty) {
        executeHive(
          () async {
            _hiveManager.addUsageDateToCache(startDate, infoList);
          },
        );
      }
      state = {...state, startDate: infoList};
      return infoList;
    } catch (e) {
      rethrow;
    }
  }

  List<AppUsageData>? getUsageState(DateTime date) {
    return state[date];
  }
  void resetUsageProvider(Map<DateTime, List<AppUsageData>> data) {
    state = data;
  }
  Future<void> addCachedDataToProvider() async {
    final result = await executeHive(
      () async {
        return await _hiveManager.getAllCachedUsage();
      },
    );
    if (result is Success<Map<DateTime, List<AppUsageData>>>) {
      state = {...state, ...result.data!};
    }
  }
}

final appUsageProvider =
    StateNotifierProvider<AppUsageNotifier, Map<DateTime, List<AppUsageData>>>(
        (ref) => getIt<AppUsageNotifier>());
