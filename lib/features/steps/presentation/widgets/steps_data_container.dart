import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:track_wise_mobile_app/features/steps/presentation/steps_viewmodel.dart';
import 'package:track_wise_mobile_app/utils/change_date_mode.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class StepsDataContainer extends ConsumerWidget {
  const StepsDataContainer({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final formater =
        NumberFormat.decimalPatternDigits(locale: 'en_us', decimalDigits: 0);
    ref.watch(stepsViewModelProvider);
    final prov = ref.read(stepsViewModelProvider.notifier);
    final distanceKm = (prov.pickedDateStepsData * prov.strideLength) / 1000;
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
            "${formater.format(prov.pickedDateStepsData)} steps",
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
                      ? prov.dailyTarget
                      : prov.changeDateMode == ChangeDateMode.weekly
                          ? prov.dailyTarget * 7
                          : prov.dailyTarget * 30),
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
                "Target: ${formater.format(prov.changeDateMode == ChangeDateMode.daily ? prov.dailyTarget : prov.changeDateMode == ChangeDateMode.weekly ? prov.dailyTarget * 7 : prov.dailyTarget * 30)}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${distanceKm.toStringAsFixed(2)} km",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                "${(distanceKm * prov.weight * 0.57).round()} cal",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
