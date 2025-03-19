import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/home_view_model.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/bar_chart.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/circle_progress_bar.dart';

class AnimatedBarCircleSwitch extends StatefulWidget {
  final HomeViewModel prov;

  const AnimatedBarCircleSwitch({super.key, required this.prov});

  @override
  AnimatedBarCircleSwitchState createState() => AnimatedBarCircleSwitchState();
}

class AnimatedBarCircleSwitchState extends State<AnimatedBarCircleSwitch> {
  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: widget.prov.isBarChart ? 1 : 0)
          ..addListener(() {
            setState(() {
              _currentPage = _pageController.page!;
            });
          });
  }
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  void _onPageChanged(int index) {
    widget.prov.toggleCharts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.prov.isBarChart ? 300 : 350,
          width: double.infinity,
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: 1 - (_currentPage - 0).abs() * 0.5,
                child: GestureDetector(
                    onTap: () async {
                      await widget.prov.openCalender(context);
                    },
                    child: const CircleProgressBar()),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: 1 - (_currentPage - 1).abs() * 0.5,
                child: const BarChartWidget(),
              ),
            ],
          ),
        ),
        PageViewDotIndicator(
          currentItem: widget.prov.isBarChart ? 1 : 0,
          count: 2,
          unselectedColor: Colors.white,
          selectedColor: Colors.blue,
        ),
      ],
    );
  }
}
