import 'package:app_usage/app_usage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppUsageNotifier extends StateNotifier <Map<String,List<AppUsageInfo>>>
{
  AppUsageNotifier() :super({});
  
  Future<List<AppUsageInfo>> getUsageData(DateTime startDate,DateTime endDate) async
  {
    print(startDate);
    final String formattedDate = "${startDate.toString()};;;${endDate.toString()}";
    if(state.containsKey(formattedDate))
    {
      print('inside');
      return state[formattedDate]!;
    }
    try{
      List<AppUsageInfo> infoList = await AppUsage().getAppUsage(startDate, endDate);
      state = {...state, formattedDate : infoList};
      return infoList;
    }catch(e){
      rethrow;
    }
  }
}

final appUsageProvider = StateNotifierProvider<AppUsageNotifier,Map<String,List<AppUsageInfo>>>((ref) => AppUsageNotifier());