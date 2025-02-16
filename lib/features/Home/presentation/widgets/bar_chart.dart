import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});
  //number of hours
  
  @override
  Widget build(BuildContext context) {
    final List<double> points = [4, 8, 7, 2, 6, 10, 5];
    final avgY = points.reduce(
          (a, b) => a + b,
        ) /
        points.length;
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
                y: avgY,
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
            barGroups: _chartGroups(avgY, points),
            borderData: FlBorderData(
                border: const Border(bottom: BorderSide(), left: BorderSide())),
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: _bottomTitles),
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

List<BarChartGroupData> _chartGroups(avg,points) {
  List<BarChartGroupData> data = [];
  for (int i = 0; i < points.length; i++) {
    data.add(BarChartGroupData(x: i, barRods: [
      BarChartRodData(
          toY: points[i], color: points[i] >= avg ? ColorsManager.red : null,)
    ]));
  }
  return data;
}

SideTitles get _bottomTitles => SideTitles(

    showTitles: true,
    getTitlesWidget: (value, meta) {
      //dates to do
      String text = '${(value.toInt() + 12).toString()}/12';
      return Padding(
        padding: const EdgeInsets.only(top:  4.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      );
    });
