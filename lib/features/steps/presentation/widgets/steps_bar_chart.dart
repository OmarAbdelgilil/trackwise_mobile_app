import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:track_wise_mobile_app/features/steps/presentation/steps_viewmodel.dart';
import 'package:track_wise_mobile_app/utils/change_date_mode.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class StepsBarChart extends ConsumerStatefulWidget {
  const StepsBarChart({super.key});

  @override
  ConsumerState<StepsBarChart> createState() => _StepsBarChartState();
}

class _StepsBarChartState extends ConsumerState<StepsBarChart> {
  int touchedBarGroupIndex = -1;
  @override
  Widget build(BuildContext context) {
    final formater = NumberFormat.decimalPatternDigits(locale: 'en_us', decimalDigits: 0);
    ref.watch(stepsViewModelProvider);
    final prov = ref.read(stepsViewModelProvider.notifier);
    if (prov.barData.isEmpty) {
      return const Placeholder();
    }
    final dates = prov.barData.keys.toList();
    final durations = prov.barData.values.toList();
    if (touchedBarGroupIndex != dates.indexOf(prov.pickedDate)) {
      setState(() {
        touchedBarGroupIndex = dates.indexOf(prov.pickedDate);
      });
    }
    final avgInHours = durations.reduce(
          (a, b) => a + b,
        ) /
        durations.length;
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 45),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: BarChart(
          BarChartData(
            barTouchData: BarTouchData(
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  if (barTouchResponse != null &&
                      barTouchResponse.spot != null) {
                    setState(() {
                      touchedBarGroupIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                      prov.toggleBarTouch(dates[touchedBarGroupIndex]);
                    });
                  }
                },
                touchTooltipData: BarTouchTooltipData(
                  fitInsideVertically: true,
                  tooltipBorder: BorderSide.none,
                  tooltipMargin: 0,
                  tooltipPadding: const EdgeInsets.all(0),
                  getTooltipColor: (group) => const Color.fromARGB(0, 0, 0, 0),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                      BarTooltipItem(
                          "${formater.format(rod.toY.toInt())} steps",
                          const TextStyle(
                              color: Color.fromARGB(212, 255, 255, 255),
                              fontSize: 10)),
                )),
            extraLinesData: ExtraLinesData(horizontalLines: [
              HorizontalLine(
                y: avgInHours,
                color: ColorsManager.blue,
                strokeWidth: 1.7,
                dashArray: [3, 5],
                label: HorizontalLineLabel(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(bottom: 20),
                  show: true,
                  labelResolver: (line) => '${formater.format(line.y.toInt())} steps',
                  style: const TextStyle(
                      color: ColorsManager.blue, fontWeight: FontWeight.bold),
                ),
              ),
              HorizontalLine(
                y: 0,
                color: const Color.fromARGB(192, 255, 255, 255),
                strokeWidth: 1.7,
                dashArray: [2, 3],
              ),
            ]),
            barGroups:
                _chartGroups(avgInHours, prov.barData, touchedBarGroupIndex),
            borderData: FlBorderData(
                border: const Border(bottom: BorderSide(), left: BorderSide())),
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                  sideTitles: _bottomTitles(
                      prov.changeDateMode, dates, touchedBarGroupIndex)),
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

List<BarChartGroupData> _chartGroups(
    avg, Map<DateTime, int> barData, int touchedBarGroupIndex) {
  final dates = barData.keys.toList();
  List<BarChartGroupData> data = [];
  for (int i = 0; i < dates.length; i++) {
    final toY = barData[dates[i]]!;
    data.add(BarChartGroupData(x: i, barRods: [
      BarChartRodData(
        toY: toY.toDouble(),
        color: !(barData[dates[i]]! >= avg) ? ColorsManager.red : null,
        width: i == touchedBarGroupIndex ? 15 : 10,
      )
    ]));
  }
  return data;
}

SideTitles _bottomTitles(ChangeDateMode changeDateMode, List<DateTime> dates,
        int touchedBarGroupIndex) =>
    SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          final index = value.toInt();
          final isSelected = index == touchedBarGroupIndex;
          final endDateWeekly = DateFormat('d/M')
              .format(dates[index].add(const Duration(days: 6)));
          final text = DateFormat(
                  changeDateMode != ChangeDateMode.monthly ? 'd/M' : 'MMMyy')
              .format(dates[index]);

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: isSelected
                ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  )
                : null,
            child: Text(
              changeDateMode == ChangeDateMode.weekly
                  ? '$text-$endDateWeekly'
                  : text,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        });
