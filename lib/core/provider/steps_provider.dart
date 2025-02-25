import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepsNotifier extends StateNotifier<Map<DateTime, int>> {
  StepsNotifier() : super({});

  Future<int> getStepsUsageData(
      DateTime startDate, DateTime endDate) async {
    if (state.containsKey(startDate)) {
      return state[startDate]!;
    }
    //to be dynamic
    return 12000;
    // try {
    //   late List<Map<dynamic, dynamic>>? Steps;
    //   appsUsage = [];
    //   List<AppUsageData> infoList = [];
    //   if (appsUsage != null && appsUsage.isNotEmpty) {
    //     infoList = appsUsage.map((e) => AppUsageData.fromJson(e)).where((element) => element.usageTime.inMinutes != 0).toList();
    //   }

    //   state = {...state, startDate: infoList};
    //   return infoList;
    // } catch (e) {
    //   rethrow;
    // }
  }

  int? getStepsUsageState(DateTime date)
  {
    //check cache here
    return state[date];
  }
}

final stepsProvider =
    StateNotifierProvider<StepsNotifier, Map<DateTime, int>>(
        (ref) => StepsNotifier());


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