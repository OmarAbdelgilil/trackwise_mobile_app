import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/home_view_model.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/bar_chart.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/circle_progress_bar.dart';
import 'dart:math';

class AnimatedBarCircleSwitch extends StatefulWidget {
  final HomeViewModel prov;

  const AnimatedBarCircleSwitch({super.key, required this.prov});

  @override
  AnimatedBarCircleSwitchState createState() => AnimatedBarCircleSwitchState();
}

class AnimatedBarCircleSwitchState extends State<AnimatedBarCircleSwitch>
    with SingleTickerProviderStateMixin {
  double _dragAmount = 0.0;

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragAmount += details.primaryDelta! / 100;
      _dragAmount = _dragAmount.clamp(-pi / 2, pi / 2);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragAmount.abs() > pi / 4) {
      widget.prov.toggleCharts();
    }
    setState(() {
      _dragAmount = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double squeezeFactor = 1 - (_dragAmount.abs() / pi);
    squeezeFactor = squeezeFactor.clamp(0.2, 1.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: _onDragEnd,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: widget.prov.isBarChart
                ? Transform(
                    transform: Matrix4.identity()..scale(squeezeFactor, 1.0, 1.0),
                    alignment: Alignment.center,
                    child: const BarChartWidget(),
                  )
                : Transform(
                    transform: Matrix4.rotationY(_dragAmount),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () async {
                        await widget.prov.openCalender(context);
                      },
                      child: const CircleProgressBar(),
                    ),
                  ),
          ),
        ),
        PageViewDotIndicator(
          currentItem: widget.prov.isBarChart? 1 : 0,
          count: 2,
          unselectedColor: Colors.white,
          selectedColor: Colors.blue,
        ),
      ],
    );
  }
}
