import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/local/hive_constants.dart';

@injectable
@singleton
class HiveManager {
  //ex/////////////////////
  Future<void> addAppUsage(
      Map<String, dynamic> appUsage, String formatedDate) async {
    final box = await Hive.openBox(HiveConstants.usageBox);
    await box.put(formatedDate, appUsage);
  }
  ///////////////////////////
}
