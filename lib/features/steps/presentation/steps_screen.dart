import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/steps/presentation/steps_viewmodel.dart';
import 'package:track_wise_mobile_app/features/steps/presentation/widgets/steps_bar_chart.dart';

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
            children: [const Spacer(),IconButton(
                onPressed: () {
                  prov.openCalender(context);
                },
                icon: const Icon(Icons.calendar_month)),]
          ),
          const StepsBarChart(),
        ],
      ),
    );
  }
}
