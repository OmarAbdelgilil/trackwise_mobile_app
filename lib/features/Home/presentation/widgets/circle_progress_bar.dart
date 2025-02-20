import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/home_view_model.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';
import 'package:intl/intl.dart';

class CircleProgressBar extends ConsumerWidget {
  const CircleProgressBar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(homeProvider);
    final prov = ref.read(homeProvider.notifier);
    final String date = DateFormat("d/M").format(prov.pickedDate);
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
                      //to be dynamic
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
                      const Text(
                        '2 hours less than yesterday',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ))
                ],
                minimum: 0,
                maximum: 24,
                //change where the progress will start
                startAngle: 90,
                endAngle: 90 + 360,
                showLabels: false,
                showTicks: false,
                radiusFactor: 0.65,
                axisLineStyle: const AxisLineStyle(thickness: 4.7),
                pointers: const <GaugePointer>[
                  RangePointer(
                      value: 12,
                      enableAnimation: true,
                      color: Color.fromARGB(255, 23, 139, 241),
                      width: 5.1,
                      cornerStyle: CornerStyle.bothCurve,
                      animationType: AnimationType.ease)
                ],
              )
            ])));
  }
}
