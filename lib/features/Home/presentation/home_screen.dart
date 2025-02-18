import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/home_view_model.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/nav_bar_router/nav_bar_router.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/app_tile.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/bar_chart.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/bottom_nav_bar.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/circle_progress_bar.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/scaffold_app_bar.dart';
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
          return value['widget'] is! HomeScreen ? value['widget'] : 
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:18.0.h),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(onTap: ()async{await prov.openCalender(context);}, child: const CircleProgressBar()),
                  //const BarChartWidget(),
                  Container(alignment: Alignment.centerLeft,padding: EdgeInsets.only(left: 8.h) ,child: const Text(StringsManager.apps,style: TextStyle(color: Colors.white,fontSize: 20),)),
                  SizedBox(
                    height: 290.h,
                    child: ListView(
                      children: const [
                        AppTile()
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      )
    );
  }
}