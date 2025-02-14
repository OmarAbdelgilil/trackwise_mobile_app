import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

class CircleProgressBar extends StatelessWidget {
  const CircleProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
  child: Align(
    alignment: Alignment.bottomCenter, 
    heightFactor: 0.9,child: SfRadialGauge(axes: <RadialAxis>[
                      RadialAxis(
                        annotations: const [
                          GaugeAnnotation(widget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(StringsManager.screenTime,style: TextStyle(color: Colors.white,fontSize: 16),),
                              //to be dynamic
                              Text('Today',style: TextStyle(color: Colors.white,fontSize: 13),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.baseline, // Aligns text based on their baseline
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text('12',style: TextStyle(color: Colors.white,fontSize: 32),),
                                  Text('hrs',style: TextStyle(color: Colors.white,fontSize: 12),),
                                ],
                              ),
                              Text('2 hours less than yesterday',style: TextStyle(color: Colors.white,fontSize: 12),),
                            ],
                          )
                          )
                        ],
                        minimum: 0,
                        maximum: 24,
                        //change where the progress will start
                        startAngle: 90,
                        endAngle: 90 + 360,
                        showLabels: false,
                        showTicks: false,
                        radiusFactor: 0.7,
                        axisLineStyle: const AxisLineStyle(
                          thickness: 4.7
                        ),
                        pointers: const <GaugePointer>[RangePointer(value: 12,enableAnimation: true,color: Color.fromARGB(255, 23, 139, 241),width: 5.1,cornerStyle: CornerStyle.bothCurve,animationType: AnimationType.ease)],
                      )
                    ])));
  }
}