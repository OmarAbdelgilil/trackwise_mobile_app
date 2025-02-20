import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/home_view_model.dart';
import 'package:track_wise_mobile_app/utils/change_date_mode.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';
import 'package:intl/intl.dart';

class CircleProgressBar extends ConsumerWidget {
  const CircleProgressBar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(homeProvider);
    final prov = ref.read(homeProvider.notifier);
    final endDateWeekly = prov.pickedDate.add(const Duration(days: 7));
    final String date = prov.changeDateMode == ChangeDateMode.weekly ? '${prov.pickedDate.day}/${prov.pickedDate.month}-${endDateWeekly.day}/${endDateWeekly.month}' : DateFormat(prov.changeDateMode == ChangeDateMode.monthly ? "MMMyy" : prov.pickedDate.year == DateTime.now().year ? "d/M" : "d/M/yy").format(prov.pickedDate);
    return ClipRect(
        child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.86,
            child: SfRadialGauge(axes: <RadialAxis>[
              RadialAxis(
                annotations: [
                  GaugeAnnotation(
                      widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        StringsManager.screenTime,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        date,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                                  prov.totalUsageTime!.inHours.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 32),
                                ),
                          const Text(
                            'hrs',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        prov.getCompareText(prov.totalUsageTime, prov.totalUsageTimeToCompare, prov.changeDateMode),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ))
                ],
                minimum: 0,
                maximum: prov.changeDateMode == ChangeDateMode.daily? 24 : prov.changeDateMode == ChangeDateMode.weekly? 168 : 730.001,
                //change where the progress will start
                startAngle: 90,
                endAngle: 90 + 360,
                showLabels: false,
                showTicks: false,
                radiusFactor: 0.65,
                axisLineStyle: const AxisLineStyle(thickness: 4.7),
                pointers: <GaugePointer>[
                  RangePointer(
                      value: prov.totalUsageTime!.inHours.toDouble(),
                      enableAnimation: true,
                      color: const Color.fromARGB(255, 23, 139, 241),
                      width: 5.1,
                      cornerStyle: CornerStyle.bothCurve,
                      animationType: AnimationType.ease)
                ],
              )
            ])));
  }
}
