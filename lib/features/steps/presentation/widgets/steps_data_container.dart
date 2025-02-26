import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/steps/presentation/steps_viewmodel.dart';
import 'package:track_wise_mobile_app/utils/change_date_mode.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class StepsDataContainer extends ConsumerWidget {
  const StepsDataContainer({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(stepsViewModelProvider);
    final prov = ref.read(stepsViewModelProvider.notifier);
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(horizontal: 18.0.w),
      decoration: BoxDecoration(
        color: ColorsManager.containerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${prov.pickedDateStepsData} steps",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (prov.pickedDateStepsData) /
                  (prov.changeDateMode == ChangeDateMode.daily
                      ? 6000
                      : prov.changeDateMode == ChangeDateMode.weekly
                          ? 6000 * 7
                          : 6000 * 30),
              backgroundColor: Colors.grey[800],
              valueColor:
                  const AlwaysStoppedAnimation<Color>(ColorsManager.blue),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "0",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Target: ${(prov.changeDateMode == ChangeDateMode.daily ? 6000 : prov.changeDateMode == ChangeDateMode.weekly ? 6000 * 7 : 6000 * 30)}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${(prov.pickedDateStepsData * 0.75) / 1000} km",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                "${((prov.pickedDateStepsData * 0.75) / 1000) * 70 * 0.57} cal",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
