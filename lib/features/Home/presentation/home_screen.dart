import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/home_view_model.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/nav_bar_router/nav_bar_router.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/animated_bar_circle_switch.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/apps_list_view.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/bottom_nav_bar.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/home_toggle_button.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/scaffold_app_bar.dart';
import 'package:track_wise_mobile_app/utils/change_date_mode.dart';
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
        appBar: const ScaffoldAppBar(),
        bottomNavigationBar: const BottomNavBar(),
        body: ValueListenableBuilder<Map<String, dynamic>>(
            valueListenable: currentPageNotifier,
            builder: (context, value, child) {
              final providerState = ref.watch(homeProvider);
              return value['widget'] is! HomeScreen
                  ? value['widget']
                  : providerState is HomeLoadingState ||
                          providerState is InitialState
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.0.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    HomeToggleButton(
                                        prov: prov,
                                        text: StringsManager.daily,
                                        toggle: ChangeDateMode.daily),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    HomeToggleButton(
                                        prov: prov,
                                        text: StringsManager.weekly,
                                        toggle: ChangeDateMode.weekly),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    HomeToggleButton(
                                        prov: prov,
                                        text: StringsManager.monthly,
                                        toggle: ChangeDateMode.monthly),
                                  ],
                                ),
                                if (prov.isBarChart) ...[
                                  Row(
                                    children: [
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () async {
                                            await prov.openCalender(context);
                                          },
                                          icon:
                                              const Icon(Icons.calendar_month))
                                    ],
                                  )
                                ],
                                // SwipeAnimation(prov: prov),
                                AnimatedBarCircleSwitch(
                                  prov: prov,
                                ),
                                // GestureDetector(
                                //     onTap: () async {
                                //       await prov.openCalender(context);
                                //     },
                                //     child: const CircleProgressBar()),
                                // const BarChartWidget(),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 8.h),
                                    child: const Text(
                                      StringsManager.apps,
                                      style: TextStyle(fontSize: 20),
                                    )),
                                const AppsListView()
                              ],
                            ),
                          ),
                        );
            }));
  }
}
