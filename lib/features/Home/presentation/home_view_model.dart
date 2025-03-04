import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/core/provider/usage_provider.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/use_cases/check_user_cache_use_case.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';
import 'package:track_wise_mobile_app/utils/change_date_mode.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

@injectable
class HomeViewModel extends StateNotifier<HomeState> {
  late final ProviderContainer _providerContainer;
  late DateTime pickedDate;
  //Map<DateTime, Map<ChangeDateMode, List<AppUsageData>>> appUsageInfoMap = {};
  //final Map<DateTime, List<AppUsageData>> _appUsageInfo = {};
  List<AppUsageData> appsList = [];
  ChangeDateMode changeDateMode = ChangeDateMode.daily;
  String compareText = '';
  bool isBarChart = false;
  Map<DateTime, Duration> barData = {};
  final CheckUserCacheUseCase _checkUserCacheUseCase;
  HomeViewModel(this._checkUserCacheUseCase) : super(InitialState()) {
    _providerContainer = ProviderContainer();
    _initFunction();
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
    state = LoadingAppsList();
    appsList = List.from(_getUsageInfo(pickedDate, changeDateMode));
    if (isBarChart) {
      _updateBarData(pickedDate);
    }
    state = DatePicked();
  }

  void toggleBarTouch(DateTime date) {
    pickedDate = date;
    state = LoadingAppsList();
    appsList = List.from(_getUsageInfo(pickedDate, changeDateMode));
    state = DatePicked();
  }

  Future<void> _getCompareText(
      DateTime myDate, ChangeDateMode changeDateMode) async {
    ///////////////////////////////////
    DateTime startDateCompare = DateTime(
      myDate.year,
      changeDateMode == ChangeDateMode.monthly
          ? myDate.month - 1
          : myDate.month,
      changeDateMode == ChangeDateMode.daily
          ? myDate.day - 1
          : changeDateMode == ChangeDateMode.weekly
              ? myDate.day - 7
              : 1,
    );

    List<AppUsageData>? infoCompare =
        _getUsageInfo(startDateCompare, changeDateMode, isCompare: true);
    final nowInfo = _getUsageInfo(myDate, changeDateMode, isCompare: true);

    final totalUsageTimeToCompare = infoCompare.fold(
      const Duration(minutes: 0),
      (Duration? a, AppUsageData b) => a! + b.usageTime,
    );
    final totalUsageTimePicked = nowInfo.fold(
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

  void toggleDateMode(ChangeDateMode mode) async {
    if (changeDateMode != mode) {
      changeDateMode = mode;
      state = LoadingAppsList();
      appsList = List.from(_getUsageInfo(pickedDate, changeDateMode));
      if (isBarChart) {
        _updateBarData(pickedDate);
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

  void _updateBarData(DateTime pickedDateEndBar) {
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
      final appList = _getUsageInfo(date, changeDateMode);
      result.addAll({date: getTotalUsage(appList)});
    }
    barData = result;
    state = BarDataUpdated();
  }

  void toggleCharts() {
    if (isBarChart) {
      isBarChart = false;
      _getCompareText(pickedDate, changeDateMode);
      state = ToggleCharts();
    } else {
      //state updates in _updateBarData
      isBarChart = true;
      if (barData.isEmpty) {
        _updateBarData(pickedDate);
      }
    }
    state = ToggleCharts();
  }

  Future<void> _initFunction() async {
    await _checkUserCacheUseCase.checkCache();
    final prov = _providerContainer.read(appUsageProvider.notifier);
    final now = DateTime.now();
    pickedDate = DateTime(now.year, now.month, now.day);
    await prov.addCachedDataToProvider();
    for (int i = 10; i >= 0; i--) {
      final startDate =
          DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final endDate =
          DateTime(startDate.year, startDate.month, startDate.day, 23, 59, 59);
      await prov.getUsageData(startDate, endDate);
    }
    appsList = prov.getUsageState(pickedDate)!;
    appsList.sort((a, b) => b.usageTime.compareTo(a.usageTime));
    if (!isBarChart) {
      _getCompareText(pickedDate, changeDateMode);
    }
    state = UsageUpdated();
  }

  List<AppUsageData> _getUsageInfo(
      DateTime startPickedDate, ChangeDateMode currentChangeDateMode,
      {bool isCompare = false}) {
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
    Map<String, AppUsageData> result = {};
    final prov = _providerContainer.read(appUsageProvider.notifier);
    if (currentChangeDateMode == ChangeDateMode.monthly) {
      startPickedDate =
          DateTime(startPickedDate.year, startPickedDate.month, 1);
    }
    for (int i = 0; i < length; i++) {
      final date = startPickedDate.add(Duration(days: i));
      for (AppUsageData app in prov.getUsageState(date) ?? []) {
        if (result.containsKey(app.appName)) {
          result[app.appName]!.usageTime = Duration(
              minutes: result[app.appName]!.usageTime.inMinutes +
                  app.usageTime.inMinutes);
        } else {
          result[app.appName] = AppUsageData(
              appName: app.appName,
              usageTime: app.usageTime,
              appIcon: app.appIcon);
        }
      }
    }
    final List<AppUsageData> sortedList = result.values.toList();
    sortedList.sort((a, b) => b.usageTime.compareTo(a.usageTime));
    if (!isCompare && !isBarChart) {
      _getCompareText(startPickedDate, currentChangeDateMode);
    }
    return sortedList;
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

class LoadingAppsList extends HomeState {}

class ToggleCharts extends HomeState {}

class SuccessState extends HomeState {
  final User user;
  SuccessState(this.user);
}

class ErrorState extends HomeState {
  final Exception error;
  ErrorState(this.error);
}
