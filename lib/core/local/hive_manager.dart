import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/local/hive_constants.dart';

@injectable
@singleton
class HiveManager {
  //ex/////////////////////
  Future<void> addAppUsage(
      Map<String, dynamic> appUsage, String formatedDate) async {
    late Box box;
    if (Hive.isBoxOpen(HiveConstants.usageBox)) {
      box = Hive.box(HiveConstants.usageBox);
    } else {
      Hive.openBox(HiveConstants.usageBox);
    }
    if (!box.containsKey(formatedDate)) {
      await box.put(formatedDate, appUsage);
    }
  }
  ///////////////////////////
}
