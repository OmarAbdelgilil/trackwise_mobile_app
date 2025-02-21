import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/home_view_model.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/nav_bar_router/nav_bar_router.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/apps_list_view.dart';
// import 'package:track_wise_mobile_app/features/Home/presentation/widgets/bar_chart.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/bottom_nav_bar.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/circle_progress_bar.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/scaffold_app_bar.dart';
import 'package:track_wise_mobile_app/utils/change_date_mode.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final prov = ref.read(homeProvider.notifier);
    return Scaffold(
      appBar:const ScaffoldAppBar(),
      bottomNavigationBar: const BottomNavBar(),
      backgroundColor: ColorsManager.backgroundColor,
      body: ValueListenableBuilder<Map<String,dynamic>>(
        valueListenable: currentPageNotifier,
        builder: (context, value, child) {
          final providerState = ref.watch(homeProvider);
          return providerState is InitialState || (prov.appUsageInfoMap[prov.pickedDate] == null || prov.appUsageInfoMap[prov.pickedDate]![prov.changeDateMode] == null)?  const Center(child: CircularProgressIndicator()) :
          value['widget'] is! HomeScreen ? value['widget'] : 
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:18.0.h),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: (){prov.toggleDateMode(ChangeDateMode.daily);},style: ButtonStyle(
                        backgroundColor: ChangeDateMode.daily == prov.changeDateMode
                            ? WidgetStateProperty.all<Color>(
                                Theme.of(context).colorScheme.primary)
                            : WidgetStateProperty.all<Color>(Colors.white),
                        foregroundColor: ChangeDateMode.daily == prov.changeDateMode
                            ? WidgetStateProperty.all<Color>(Colors.white)
                            : WidgetStateProperty.all<Color>(
                                Theme.of(context).colorScheme.primary),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ))), child: const Text(StringsManager.daily),),
                      const SizedBox(width: 2,),
                      ElevatedButton(onPressed: (){prov.toggleDateMode(ChangeDateMode.weekly);},style: ButtonStyle(
                        backgroundColor: ChangeDateMode.weekly == prov.changeDateMode
                            ? WidgetStateProperty.all<Color>(
                                Theme.of(context).colorScheme.primary)
                            : WidgetStateProperty.all<Color>(Colors.white),
                        foregroundColor: ChangeDateMode.weekly == prov.changeDateMode
                            ? WidgetStateProperty.all<Color>(Colors.white)
                            : WidgetStateProperty.all<Color>(
                                Theme.of(context).colorScheme.primary),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ))), child: const Text(StringsManager.weekly),),
                      const SizedBox(width: 2,),
                      ElevatedButton(onPressed: (){prov.toggleDateMode(ChangeDateMode.monthly);},style: ButtonStyle(
                        backgroundColor: ChangeDateMode.monthly == prov.changeDateMode
                            ? WidgetStateProperty.all<Color>(
                                Theme.of(context).colorScheme.primary)
                            : WidgetStateProperty.all<Color>(Colors.white),
                        foregroundColor: ChangeDateMode.monthly == prov.changeDateMode
                            ? WidgetStateProperty.all<Color>(Colors.white)
                            : WidgetStateProperty.all<Color>(
                                Theme.of(context).colorScheme.primary),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ))), child: const Text(StringsManager.monthly),),
                    ],
                  ),
                  GestureDetector(onTap: ()async{await prov.openCalender(context);}, child: const CircleProgressBar()),
                  // const BarChartWidget(),
                  Container(alignment: Alignment.centerLeft,padding: EdgeInsets.only(left: 8.h) ,child: const Text(StringsManager.apps,style: TextStyle(color: Colors.white,fontSize: 20),)),
                  const AppsListView()
                ],
              ),
            ),
          );
        }
      )
    );
  }
}