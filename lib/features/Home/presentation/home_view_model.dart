import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/core/provider/usage_provider.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';
import 'package:track_wise_mobile_app/utils/change_date_mode.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

@injectable
class HomeViewModel extends StateNotifier<HomeState> {
  late final ProviderContainer _providerContainer;
  late DateTime pickedDate;
  Map<DateTime, Map<ChangeDateMode, List<AppUsageData>>> appUsageInfoMap = {};
  ChangeDateMode changeDateMode = ChangeDateMode.daily;
  String compareText = '';
  bool isBarChart = false;
  Map<DateTime, Duration> barData = {};
  HomeViewModel() : super(InitialState()) {
    _providerContainer = ProviderContainer();
    final now = DateTime.now();
    pickedDate = DateTime(now.year, now.month, now.day);
    if(isBarChart)
    {
      _updateBarData(pickedDate);
    }else{
      _getUsageData(pickedDate);
    }
  }

  Future<void> _getUsageData(DateTime startPickedDate) async {
    pickedDate = changeDateMode == ChangeDateMode.monthly
        ? DateTime(startPickedDate.year, startPickedDate.month, 1)
        : startPickedDate;
    startPickedDate = pickedDate;
    DateTime endDate = changeDateMode == ChangeDateMode.daily
        ? DateTime(startPickedDate.year, startPickedDate.month,
            startPickedDate.day, 23, 59, 59)
        : changeDateMode == ChangeDateMode.weekly
            ? startPickedDate.add(const Duration(days: 7))
            : DateTime(startPickedDate.year, startPickedDate.month + 1, 1);
    //check if it doesn't exist
    if (appUsageInfoMap[startPickedDate] == null ||
        appUsageInfoMap[startPickedDate]![changeDateMode] == null ||
        appUsageInfoMap[startPickedDate]![changeDateMode]!.isEmpty) {
      if (!isBarChart) {
        state = HomeLoadingState();
      }
      List<AppUsageData> appInfoTemp = await _providerContainer
          .read(appUsageProvider.notifier)
          .getUsageData(startPickedDate, endDate);
      appInfoTemp.sort((a, b) => b.usageTime.compareTo(a.usageTime));
      appUsageInfoMap[startPickedDate] ??= {};
      appUsageInfoMap[startPickedDate]![changeDateMode] = [...appInfoTemp];
    }
    if (!isBarChart) {
      await _getCompareText(startPickedDate, changeDateMode);
      state = UsageUpdated();
    }
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
    state = DatePicked();
    if(isBarChart)
    {
      _updateBarData(pickedDate);
    }else{
      await _getUsageData(pickedDate);
    }

  }

  Future<void> _getCompareText(
      DateTime myDate, ChangeDateMode changeDateMode) async {
    ///////////////////////////////////
    DateTime endDate = changeDateMode == ChangeDateMode.daily
        ? DateTime(myDate.year, myDate.month, myDate.day, 23, 59, 59)
        : changeDateMode == ChangeDateMode.weekly
            ? myDate.add(const Duration(days: 7))
            : DateTime(myDate.year, myDate.month + 1, 1);
    DateTime startDateCompare = DateTime(
        myDate.year,
        changeDateMode == ChangeDateMode.monthly
            ? myDate.month - 1
            : myDate.month,
        changeDateMode == ChangeDateMode.daily
            ? myDate.day - 1
            : changeDateMode == ChangeDateMode.weekly
                ? myDate.day - 7
                : myDate.day,
        myDate.hour,
        myDate.minute,
        myDate.second);
    DateTime endDateCompare = DateTime(
        endDate.year,
        changeDateMode == ChangeDateMode.monthly
            ? endDate.month - 1
            : endDate.month,
        changeDateMode == ChangeDateMode.daily
            ? endDate.day - 1
            : changeDateMode == ChangeDateMode.weekly
                ? endDate.day - 7
                : endDate.day,
        endDate.hour,
        endDate.minute,
        endDate.second);

    List<AppUsageData>? infoCompare =
        appUsageInfoMap[startDateCompare]?[changeDateMode];
    if (infoCompare == null) {
      List<AppUsageData> appInfoTemp = await _providerContainer
          .read(appUsageProvider.notifier)
          .getUsageData(startDateCompare, endDateCompare);
      appInfoTemp = appInfoTemp
          .where((element) => element.usageTime.inMinutes != 0)
          .toList();
      appInfoTemp.sort((a, b) => b.usageTime.compareTo(a.usageTime));
      appUsageInfoMap[startDateCompare] ??= {};
      appUsageInfoMap[startDateCompare]![changeDateMode] = [...appInfoTemp];
    }
    final totalUsageTimeToCompare =
        appUsageInfoMap[startDateCompare]![changeDateMode]!.fold(
      const Duration(minutes: 0),
      (Duration? a, AppUsageData b) => a! + b.usageTime,
    );
    final totalUsageTimePicked = appUsageInfoMap[myDate]![changeDateMode]!.fold(
      const Duration(minutes: 0),
      (Duration? a, AppUsageData b) => a! + b.usageTime,
    );
    //////////////////////////////////
    String finalPart = changeDateMode == ChangeDateMode.daily
        ? 'yesterday'
        : changeDateMode == ChangeDateMode.weekly
            ? 'last week'
            : 'last month';
    final diff = totalUsageTimePicked.inHours - totalUsageTimeToCompare.inHours;
    if (diff == 0) {
      compareText = 'same Amount of time as $finalPart';
    } else if (diff > 0) {
      compareText = '$diff hours more than $finalPart';
    } else {
      compareText = '${-1 * diff} hours less than $finalPart';
    }
  }

  void toggleDateMode(ChangeDateMode mode) async{
    if (changeDateMode != mode) {
      changeDateMode = mode;
      
      if(isBarChart)
      {
        await _getUsageData(pickedDate);
        _updateBarData(pickedDate);
      }else{
        _getUsageData(pickedDate);
      }
      state = DateModeChanged();
    }
  }

  Duration getTotalUsage(List<AppUsageData> listData) {
    return listData.fold(
      const Duration(minutes: 0),
      (Duration? a, AppUsageData b) => a! + b.usageTime,
    );
  }

  Future<void> _updateBarData(DateTime pickedDateEndBar) async {
    state = HomeLoadingState();
    Map<DateTime, Duration> result = {};
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
      await _getUsageData(date);
      result.addAll(
          {date: getTotalUsage(appUsageInfoMap[date]![changeDateMode]!)});
    }
    barData = result;
    state = BarDataUpdated();
  }
}

final homeProvider = StateNotifierProvider<HomeViewModel, HomeState>(
    (ref) => getIt<HomeViewModel>());

sealed class HomeState {}

class InitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class DatePicked extends HomeState {}

class UsageUpdated extends HomeState {}

class BarDataUpdated extends HomeState {}

class DateModeChanged extends HomeState {}

class SuccessState extends HomeState {
  final User user;
  SuccessState(this.user);
}

class ErrorState extends HomeState {
  final Exception error;
  ErrorState(this.error);
}
