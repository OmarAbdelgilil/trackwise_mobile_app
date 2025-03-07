import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/core/provider/steps_provider.dart';
import 'package:track_wise_mobile_app/utils/change_date_mode.dart';

@injectable
class StepsViewmodel extends StateNotifier<StepsState> {
  late final ProviderContainer _providerContainer;
  final SharedPreferences _prefs;
  late DateTime pickedDate;
  int pickedDateStepsData = 15000;
  int dailyTarget = 6000;
  int weight = 70;
  double strideLength = 0.75;
  ChangeDateMode changeDateMode = ChangeDateMode.daily;
  Map<DateTime, int> barData = {};
  StepsViewmodel(this._prefs) : super(InitialState()) {
    _providerContainer = ProviderContainer();
    initFunction();
  }

  void initFunction() async
  {
    final prov = _providerContainer.read(stepsProvider.notifier);
    final now = DateTime.now();
    pickedDate = DateTime(now.year, now.month, now.day);
    pickedDateStepsData = _getUsageInfo(pickedDate, changeDateMode);
    await prov.addCachedDataToProvider();
    dailyTarget = _prefs.getInt('dailyTarget') ?? dailyTarget;
    weight = _prefs.getInt('weight') ?? weight;
    strideLength = _prefs.getDouble('strideLength') ?? strideLength;
    _updateBarData(pickedDate);
  }
  Future<void> openCalender(BuildContext context) async {
    final now = DateTime.now();
    DateTime? pickedDateTemp = await (changeDateMode != ChangeDateMode.monthly
        ? showDatePicker(
            context: context,
            initialDate: pickedDate,
            firstDate: now.subtract(const Duration(days: 365 * 3)),
            lastDate: now,
          )
        : showMonthPicker(
            context: context,
            initialDate: pickedDate,
            firstDate: now.subtract(const Duration(days: 365 * 3)),
            lastDate: now,
          ));
    if (pickedDateTemp == null) {
      return;
    }
    pickedDate = pickedDateTemp;
    pickedDateStepsData = _getUsageInfo(pickedDate, changeDateMode);
    _updateBarData(pickedDate);
    state = DatePicked();
  }

  void toggleBarTouch(DateTime date) {
    pickedDate = date;
    //update list
    pickedDateStepsData = _getUsageInfo(pickedDate, changeDateMode);
    state = DatePicked();
  }

  void toggleDateMode(ChangeDateMode mode) async {
    if (changeDateMode != mode) {
      changeDateMode = mode;
      pickedDateStepsData = _getUsageInfo(pickedDate, changeDateMode);
      _updateBarData(pickedDate);
      state = DateModeChanged();
    }
  }

  void _updateBarData(DateTime pickedDateEndBar) {
    Map<DateTime, int> result = {};
    int length = changeDateMode == ChangeDateMode.daily ? 7 : 4;
    for (int i = 1; i <= length; i++) {
      late DateTime date;
      switch (changeDateMode) {
        case ChangeDateMode.daily:
          date = pickedDateEndBar.subtract(Duration(days: length - i));
          break;
        case ChangeDateMode.weekly:
          date = pickedDateEndBar.subtract(Duration(days: 7 * (length - i)));
          break;
        case ChangeDateMode.monthly:
          date = DateTime(pickedDateEndBar.year,
              pickedDateEndBar.month - (length - i), pickedDateEndBar.day);
          break;
      }
      final usage = _getUsageInfo(date, changeDateMode);
      result.addAll({date: usage});
    }
    barData = result;
    state = BarDataUpdated();
  }

  void setStepsData({required int myWeight,required int myDailyTarget, required double heightCm})
  {
    weight = myWeight;
    dailyTarget = myDailyTarget;
    strideLength = heightCm * 0.01 * 0.414;
    _prefs.setInt('dailyTarget', myDailyTarget);
    _prefs.setInt('weight', myWeight);
    _prefs.setDouble('strideLength', strideLength);
    state = StepsDataUpdated();
  }
  int _getUsageInfo(
      DateTime startPickedDate, ChangeDateMode currentChangeDateMode) {
    ////////******** don't update apps list or state here */
    int length = currentChangeDateMode == ChangeDateMode.daily
        ? 1
        : currentChangeDateMode == ChangeDateMode.weekly
            ? 7
            : DateTimeRange(
                start: DateTime(startPickedDate.year, startPickedDate.month, 1),
                end: DateTime(
                  startPickedDate.year,
                  startPickedDate.month + 1,
                )).duration.inDays;
    int totalUsage = 0;
    final prov = _providerContainer.read(stepsProvider.notifier);
    if (currentChangeDateMode == ChangeDateMode.monthly) {
      startPickedDate =
          DateTime(startPickedDate.year, startPickedDate.month, 1);
    }
    for (int i = 0; i < length; i++) {
      final date = startPickedDate.add(Duration(days: i));
      final dayUsage = prov.getStepsUsageState(date);
      //to be dynamic
      totalUsage = totalUsage + (dayUsage ?? 10000);
    }
    return totalUsage;
  }
}

final stepsViewModelProvider =
    StateNotifierProvider<StepsViewmodel, StepsState>(
        (ref) => getIt<StepsViewmodel>());

sealed class StepsState {}

class InitialState extends StepsState {}

class DatePicked extends StepsState {}

class DateModeChanged extends StepsState {}

class BarDataUpdated extends StepsState {}

class StepsDataUpdated extends StepsState {}
