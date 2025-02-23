import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/home_view_model.dart';
import 'package:track_wise_mobile_app/utils/change_date_mode.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class BarChartWidget extends ConsumerWidget {
  const BarChartWidget({super.key});
  
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    ref.watch(homeProvider);
    final prov = ref.read(homeProvider.notifier);
    final dates = prov.barData.keys.toList();
    final durations = prov.barData.values.toList();
    //{25/12 as DateTime: 6, 28/12: 7};
    //dynamic durations in info
    // final List<double> points = [4, 8, 7, 2, 6, 10, 5];
    final avgInHours = durations.reduce(
          (a, b) => a + b,
        ).inHours /
        durations.length;
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15),
      child: AspectRatio(
        aspectRatio: 2,
        child: BarChart(
          BarChartData(
            barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
              fitInsideVertically: true,
              tooltipBorder: BorderSide.none,
              tooltipMargin: 0,
              tooltipPadding: const EdgeInsets.all(0),
              getTooltipColor: (group) => const Color.fromARGB(0, 0, 0, 0),
              getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem("${rod.toY.toInt().toString()} hrs",const TextStyle(color: Color.fromARGB(212, 255, 255, 255),fontSize: 10)),
            )),
            extraLinesData: ExtraLinesData(horizontalLines: [
              HorizontalLine(
                y: avgInHours,
                color: ColorsManager.red,
                strokeWidth: 1.7,
                dashArray: [3, 5],
                label: HorizontalLineLabel(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(bottom: 20),
                  show: true,
                  labelResolver: (line) => '${line.y.toInt()}hrs',
                  style: const TextStyle(
                      color: ColorsManager.red, fontWeight: FontWeight.bold),
                ),
              ),
              HorizontalLine(
                y: 0,
                color: const Color.fromARGB(192, 255, 255, 255),
                strokeWidth: 1.7,
                dashArray: [2, 3],
              ),
            ]),
            barGroups: _chartGroups(avgInHours, prov.barData),
            borderData: FlBorderData(
                border: const Border(bottom: BorderSide(), left: BorderSide())),
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: _bottomTitles(prov.changeDateMode, dates)),
              leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
        ),
      ),
    );
  }
}

List<BarChartGroupData> _chartGroups(avg, Map<DateTime, Duration> barData) {
  final dates = barData.keys.toList();
  List<BarChartGroupData> data = [];
  for (int i = 0; i < dates.length; i++) {
    data.add(BarChartGroupData(x: i, barRods: [
      BarChartRodData(
          toY: barData[dates[i]]!.inHours.toDouble(), color: barData[dates[i]]!.inHours >= avg ? ColorsManager.red : null,)
    ]));
  }
  return data;
}

SideTitles _bottomTitles(ChangeDateMode changeDateMode,List<DateTime> dates) => SideTitles(
    showTitles: true,
    getTitlesWidget: (value, meta) {
      final text = DateFormat(changeDateMode != ChangeDateMode.monthly? 'd/M' : 'MMMyy').format(dates[value.toInt()]);
      return Padding(
        padding: const EdgeInsets.only(top:  4.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      );
    });
