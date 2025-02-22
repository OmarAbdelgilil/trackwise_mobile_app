import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/home_view_model.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/app_tile.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

class AppsListView extends ConsumerWidget {
  const AppsListView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final prov = ref.read(homeProvider.notifier);
    ref.watch(homeProvider);
    late AppUsageData? maxUsage;
    Widget? emptyCheck;
    if(prov.appUsageInfoMap[prov.pickedDate] == null || prov.appUsageInfoMap[prov.pickedDate]![prov.changeDateMode] == null || prov.appUsageInfoMap[prov.pickedDate]![prov.changeDateMode]!.isEmpty)
    {
      emptyCheck = const Center(child: Text(StringsManager.noAppsFound,style: TextStyle(color: Colors.white ,fontWeight: FontWeight.bold),));
    }else{
      maxUsage = prov.appUsageInfoMap[prov.pickedDate]![prov.changeDateMode]!.reduce((a, b) => a.usageTime > b.usageTime ? a : b);
    }
    return  SizedBox(
                    height: 265.h,
                    child: emptyCheck ?? ListView(
                      children: [
                        for(AppUsageData app in prov.appUsageInfoMap[prov.pickedDate]![prov.changeDateMode]!)
                          AppTile(appData: app,maxUsage:maxUsage == null? const Duration(minutes: 0) :  maxUsage.usageTime)
                      ],
                    ),
                  );
  }
}