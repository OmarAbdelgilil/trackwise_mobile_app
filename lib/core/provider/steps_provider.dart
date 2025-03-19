import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
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
    await Permission.activityRecognition.request();
    if (state.containsKey(startDate)) {
      return state[startDate]!;
    }
    const platform = MethodChannel('usage_stats');
    // int _steps = 0;
    int steps = 0;
    String formattedDate = DateFormat('dd-MM-yyyy').format(startDate);
    try {
      steps = await platform.invokeMethod('getSteps', {"date": formattedDate});
      print(steps);
        executeHive(
          () async {
            _hiveManager.addStepsDateToCache(startDate, steps);
          },
        );
      state = {...state, startDate: steps};
    } on PlatformException catch (e) {
      print("Failed to get step count: '${e.message}'.");
    }
    //to be dynamic
    return steps;
    // try {
    //   late List<Map<dynamic, dynamic>>? Steps;
    //   appsUsage = [];
    //   List<AppUsageData> infoList = [];
    //   if (appsUsage != null && appsUsage.isNotEmpty) {
    //     infoList = appsUsage.map((e) => AppUsageData.fromJson(e)).where((element) => element.usageTime.inMinutes != 0).toList();
    //   }
    // if (infoList.isNotEmpty) {
    //   executeHive(
    //     () async {
    //       _hiveManager.addStepsDateToCache(startDate, );
    //     },
    //   );
    // }
    //   state = {...state, startDate: infoList};
    //   return infoList;
    // } catch (e) {
    //   rethrow;
    // }
  }
  void resetStepsProvider(Map<DateTime, int> data) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    data.remove(todayDate);
    if(state.containsKey(todayDate) && state[todayDate] != null)
    {
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
  void clearProvider()
  {
    state = {};
  }
}

final stepsProvider = StateNotifierProvider<StepsNotifier, Map<DateTime, int>>(
    (ref) => getIt<StepsNotifier>());


// health.isHealthConnectAvailable().then(
//           (bool isAvailable) async {
//             print('isAvailable $isAvailable');
//             if (!isAvailable) {
//               print("Health Connect is not installed. Prompting the user...");
//               await health.installHealthConnect();
//             }
//             health
//                 .requestAuthorization(types, permissions: permissions)
//                 .then((bool granted) async {
//               print('granted $granted');
//               if (granted) {
//                 DateTime startDate = DateTime.now().subtract(Duration(days: 1));
//                 DateTime endDate = DateTime.now();
//                 List<HealthDataPoint> healthData =
//                     await health.getHealthDataFromTypes(
//                   types: types,
//                   startTime: startDate,
//                   endTime: endDate,
//                 );
//                 print(healthData[0].metadata);
//               }
//             });
//           },
//         );