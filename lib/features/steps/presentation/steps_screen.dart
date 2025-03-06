import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/home_toggle_button.dart';
import 'package:track_wise_mobile_app/features/steps/presentation/steps_viewmodel.dart';
import 'package:track_wise_mobile_app/features/steps/presentation/widgets/steps_bar_chart.dart';
import 'package:track_wise_mobile_app/features/steps/presentation/widgets/steps_data_container.dart';
import 'package:track_wise_mobile_app/features/steps/presentation/widgets/steps_data_dialog.dart';
import 'package:track_wise_mobile_app/utils/change_date_mode.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

class StepsScreen extends ConsumerWidget {
  const StepsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final stepsScreenState = ref.watch(stepsViewModelProvider);
    final prov = ref.read(stepsViewModelProvider.notifier);
    if (stepsScreenState is InitialState) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
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
          Row(
            children: [
              const Spacer(),
              IconButton(
                  onPressed: () async {
                    await prov.openCalender(context);
                  },
                  icon: const Icon(Icons.calendar_month))
            ],
          ),
          const StepsBarChart(),
          SizedBox(
            height: 20.h,
          ),
          const StepsDataContainer(),
          const SizedBox(height: 4),
          TextButton(
              onPressed: (){showStepsDataDialogDialog(context, prov);},
              child: const Text(
                "Enter weight and height for better readings",
                style: TextStyle(color: Colors.blue, fontSize: 14),
              )),
        ],
      ),
    );
  }
}
