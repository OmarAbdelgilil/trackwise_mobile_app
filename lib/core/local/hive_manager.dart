import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/local/hive_constants.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';
import 'package:weekly_date_picker/datetime_apis.dart';

@injectable
class HiveManager {
  Future<Map<DateTime, List<AppUsageData>>> getAllCachedUsage() async {
    Map<DateTime, List<AppUsageData>> usageData = {};
    late Box box;
    if (Hive.isBoxOpen(HiveConstants.usageBox)) {
      box = Hive.box(HiveConstants.usageBox);
    } else {
      box = await Hive.openBox(HiveConstants.usageBox);
    }
    for (var key in box.keys) {
      DateTime date = DateTime.parse(key);
      List<AppUsageData> data = (box.get(key) as List)
          .map((item) => AppUsageData.fromJson(item))
          .toList();
      usageData[date] = data;
    }
    return usageData;
  }

  Future<Map<DateTime, int>> getAllCachedSteps() async {
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    Map<DateTime, int> stepsData = {};
    late Box box;
    if (Hive.isBoxOpen(HiveConstants.stepsBox)) {
      box = Hive.box(HiveConstants.stepsBox);
    } else {
      box = await Hive.openBox(HiveConstants.stepsBox);
    }
    for (var key in box.keys) {
      DateTime date = DateTime.parse(key);
      if (date.isBefore(now)) {
        int data = box.get(key);
        stepsData[date] = data;
      }
    }
    return stepsData;
  }

  void addUsageDateToCache(DateTime date, List<AppUsageData> usageData) async {
    final now = DateTime.now();
    if (date.isSameDateAs(DateTime(now.year, now.month, now.day))) {
      return;
    }
    late Box box;
    if (Hive.isBoxOpen(HiveConstants.usageBox)) {
      box = Hive.box(HiveConstants.usageBox);
    } else {
      box = await Hive.openBox(HiveConstants.usageBox);
    }
    await box.put(
        date.toIso8601String(),
        usageData.map((data) {
          return data.toJson();
        }).toList());
  }

  void addStepsDateToCache(DateTime date, int stepsData) async {
    final now = DateTime.now();
    if (date.isSameDateAs(DateTime(now.year, now.month, now.day))) {
      return;
    }
    late Box box;
    if (Hive.isBoxOpen(HiveConstants.stepsBox)) {
      box = Hive.box(HiveConstants.stepsBox);
    } else {
      box = await Hive.openBox(HiveConstants.stepsBox);
    }
    await box.put(date.toIso8601String(), stepsData);
  }

  Future<void> addAllUsageToCache(
      Map<DateTime, List<AppUsageData>> data) async {
    final now = DateTime.now();
    late Box box;
    if (Hive.isBoxOpen(HiveConstants.usageBox)) {
      box = Hive.box(HiveConstants.usageBox);
    } else {
      box = await Hive.openBox(HiveConstants.usageBox);
    }
    data.forEach(
      (date, usageData) async {
        if (date.isSameDateAs(DateTime(now.year, now.month, now.day))) {
          return;
        }
        await box.put(
            date.toIso8601String(),
            usageData.map((data) {
              return data.toJson();
            }).toList());
      },
    );
  }

  Future<void> addAllStepsToCache(Map<DateTime, int> data) async {
    final now = DateTime.now();
    late Box box;
    if (Hive.isBoxOpen(HiveConstants.stepsBox)) {
      box = Hive.box(HiveConstants.stepsBox);
    } else {
      box = await Hive.openBox(HiveConstants.stepsBox);
    }
    data.forEach(
      (date, stepsData) async {
        if (date.isSameDateAs(DateTime(now.year, now.month, now.day))) {
          return;
        }
        await box.put(date.toIso8601String(), stepsData);
      },
    );
  }

  Future<void> clearUsageCache() async {
    late Box box;
    if (Hive.isBoxOpen(HiveConstants.usageBox)) {
      box = Hive.box(HiveConstants.usageBox);
    } else {
      box = await Hive.openBox(HiveConstants.usageBox);
    }
    await box.clear();
  }

  Future<void> clearStepsCache() async {
    late Box box;
    if (Hive.isBoxOpen(HiveConstants.stepsBox)) {
      box = Hive.box(HiveConstants.stepsBox);
    } else {
      box = await Hive.openBox(HiveConstants.stepsBox);
    }
    await box.clear();
  }

  Future<void> addRecommendation(Map<String, dynamic> data) async {
    late Box box;
    if (Hive.isBoxOpen(HiveConstants.recommendationsBox)) {
      box = Hive.box(HiveConstants.recommendationsBox);
    } else {
      box = await Hive.openBox(HiveConstants.stepsBox);
    }
    await box.add(data);
  }

  Future<void> clearRecommendations(Map<String, dynamic> data) async {
    late Box box;
    if (Hive.isBoxOpen(HiveConstants.recommendationsBox)) {
      box = Hive.box(HiveConstants.recommendationsBox);
    } else {
      box = await Hive.openBox(HiveConstants.stepsBox);
    }
    await box.clear();
  }

  Future<List<dynamic>> getRecommendations(Map<String, dynamic> data) async {
    late Box box;
    if (Hive.isBoxOpen(HiveConstants.recommendationsBox)) {
      box = Hive.box(HiveConstants.recommendationsBox);
    } else {
      box = await Hive.openBox(HiveConstants.recommendationsBox);
    }
    return box.values.toList();
  }
}
