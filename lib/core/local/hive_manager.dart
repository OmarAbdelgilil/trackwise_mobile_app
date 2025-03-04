import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/local/hive_constants.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';
import 'package:weekly_date_picker/datetime_apis.dart';

@injectable
@singleton
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
}
