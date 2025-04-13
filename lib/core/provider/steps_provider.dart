import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/core/local/execute_hive.dart';
import 'package:track_wise_mobile_app/core/local/hive_manager.dart';

@injectable
class StepsNotifier extends StateNotifier<Map<DateTime, int>> {
  StepsNotifier(this._hiveManager) : super({});
  final HiveManager _hiveManager;

  Future<int> getStepsUsageData(DateTime startDate) async {
    if (state.containsKey(startDate)) {
      return state[startDate]!;
    }
    const platform = MethodChannel('usage_stats');
    int steps = 0;
    String formattedDate = DateFormat('d-M-yyyy').format(startDate);
    try {
      steps = (await platform.invokeMethod('getSteps', {"date": formattedDate}))
          .toInt();
      executeHive(
        () async {
          _hiveManager.addStepsDateToCache(startDate, steps);
        },
      );
      state = {...state, startDate: steps};
    } on PlatformException catch (e) {
      print("Failed to get step count: '${e.message}'.");
    }
    return steps;
  }

  void resetStepsProvider(Map<DateTime, int> data) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    data.remove(todayDate);
    if (state.containsKey(todayDate) && state[todayDate] != null) {
      data[todayDate] = state[todayDate]!;
    }
    state = data;
  }

  Future<void> addCachedDataToProvider() async {
    final result = await executeHive(
      () async {
        return await _hiveManager.getAllCachedSteps();
      },
    );
    if (result is Success<Map<DateTime, int>>) {
      state = {...state, ...result.data!};
    }
  }

  void clearProvider() {
    state = {};
  }
}

final stepsProvider = StateNotifierProvider<StepsNotifier, Map<DateTime, int>>(
    (ref) => getIt<StepsNotifier>());
