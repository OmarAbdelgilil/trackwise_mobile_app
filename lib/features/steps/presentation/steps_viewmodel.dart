import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/core/provider/steps_provider.dart';
import 'package:track_wise_mobile_app/features/Auth/data/repos/auth_repository_impl.dart';
import 'package:track_wise_mobile_app/main.dart';
import 'package:track_wise_mobile_app/utils/change_date_mode.dart';

@injectable
class StepsViewmodel extends StateNotifier<StepsState> {
  late final ProviderContainer _providerContainer;
  final SharedPreferences _prefs;
  late DateTime pickedDate;
  int pickedDateStepsData = 0;
  int dailyTarget = 6000;
  int weight = 70;
  double strideLength = 0.75;
  ChangeDateMode changeDateMode = ChangeDateMode.daily;
  Map<DateTime, int> barData = {};
  final AuthEventService _authEventService;
  StreamSubscription? _loginSubscription;
  StreamSubscription? _logoutSubscription;
  StepsViewmodel(this._prefs, this._authEventService) : super(InitialState()) {
    _providerContainer = providerContainer;
    _initFunction();
    _loginSubscription = _authEventService.onLoginSuccess.listen((user) {
      resetStepsWhenLogin();
    });
    _logoutSubscription = _authEventService.onLogoutSuccess.listen((event) {
      state = InitialState();
      _providerContainer.read(stepsProvider.notifier).clearProvider();
      _initFunction();

    },);
  }
  @override
  void dispose() {
    _loginSubscription?.cancel();
    _logoutSubscription?.cancel();
    super.dispose();
  }
  Future<void> _initFunction() async
  {
    final prov = _providerContainer.read(stepsProvider.notifier);
    final now = DateTime.now();
    pickedDate = DateTime(now.year, now.month, now.day);
    // await prov.addCachedDataToProvider();
    //should get all steps cached data
    pickedDateStepsData = await prov.getStepsUsageData(pickedDate);
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
    state = LoadingStepsData();
    pickedDateStepsData = await _getUsageInfo(pickedDate, changeDateMode);
    _updateBarData(pickedDate);
    state = DatePicked();
  }

  void toggleBarTouch(DateTime date) async{
    pickedDate = date;
    state = LoadingStepsData();
    pickedDateStepsData = await _getUsageInfo(pickedDate, changeDateMode);
    state = DatePicked();
  }

  void toggleDateMode(ChangeDateMode mode) async {
    if (changeDateMode != mode) {
      changeDateMode = mode;
       state = LoadingStepsData();
      pickedDateStepsData = await _getUsageInfo(pickedDate, changeDateMode);
      await _updateBarData(pickedDate);
      state = DateModeChanged();
    }
  }

  Future<void> _updateBarData(DateTime pickedDateEndBar) async{
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
      final steps = await _getUsageInfo(date, changeDateMode);
      result.addAll({date: steps});
    }
    barData = result;
    state = BarDataUpdated();
  }

  void setStepsData(
      {required int myWeight,
      required int myDailyTarget,
      required double heightCm}) {
    weight = myWeight;
    dailyTarget = myDailyTarget;
    strideLength = heightCm * 0.01 * 0.414;
    _prefs.setInt('dailyTarget', myDailyTarget);
    _prefs.setInt('weight', myWeight);
    _prefs.setDouble('strideLength', strideLength);
    state = StepsDataUpdated();
  }

  void resetStepsWhenLogin() async
  {
    final prov = _providerContainer.read(stepsProvider.notifier);
    pickedDateStepsData = await prov.getStepsUsageData(pickedDate);
    _updateBarData(pickedDate);
    state = StepsDataUpdated();
  }
  Future<int> _getUsageInfo(
      DateTime startPickedDate, ChangeDateMode currentChangeDateMode) async{
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
      int dayUsage = await prov.getStepsUsageData(date);
      totalUsage = totalUsage + dayUsage;
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

class LoadingStepsData extends StepsState {}