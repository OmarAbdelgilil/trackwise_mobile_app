import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.prov.isBarChart ? 1 : 0);
    
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
          height: widget.prov.isBarChart ? 290.h : 350.h,
          width: double.infinity,
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              GestureDetector(
                  onTap: () async {
                    await widget.prov.openCalender(context);
                  },
                  child: const CircleProgressBar()),
              const BarChartWidget(),
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
