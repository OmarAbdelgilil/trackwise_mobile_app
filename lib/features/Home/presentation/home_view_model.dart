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
  //to be map
  // Duration? totalUsageTime;
  // Duration? totalUsageTimeToCompare;
  // late List<AppUsageData> appUsageInfo;
  Map<DateTime, Map<ChangeDateMode, List<AppUsageData>>> appUsageInfoMap = {};
  ChangeDateMode changeDateMode = ChangeDateMode.daily;
  HomeViewModel() : super(InitialState()) {
    _providerContainer = ProviderContainer();
    final now = DateTime.now();
    pickedDate = DateTime(now.year, now.month, now.day);
    _getUsageData();
  }
  Future<void> _getUsageData() async {
    //to load only the first time
    //state = LoadingState();
    pickedDate = changeDateMode == ChangeDateMode.monthly? DateTime(pickedDate.year, pickedDate.month, 1) : pickedDate;
    DateTime endDate = changeDateMode == ChangeDateMode.daily? DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 23, 59, 59) : changeDateMode == ChangeDateMode.weekly? pickedDate.add(const Duration(days: 7)): DateTime(pickedDate.year, pickedDate.month + 1, 1); 
    // appUsageInfo = await _providerContainer.read(appUsageProvider.notifier).getUsageData(pickedDate, endDate);
    //check if already exists
    if(appUsageInfoMap[pickedDate] == null || appUsageInfoMap[pickedDate]![changeDateMode] == null || appUsageInfoMap[pickedDate]![changeDateMode]!.isEmpty)
    {
      List<AppUsageData> appInfoTemp = await _providerContainer.read(appUsageProvider.notifier).getUsageData(pickedDate, endDate); 
      appInfoTemp = appInfoTemp.where((element)  => element.usageTime.inMinutes != 0).toList();
      appInfoTemp.sort((a, b) => b.usageTime.compareTo(a.usageTime));
      appUsageInfoMap[pickedDate] ??= {};
      appUsageInfoMap[pickedDate]![changeDateMode] = [...appInfoTemp];
    
    }
    ///////////////////////////////////
    // DateTime startDateCompare = DateTime(pickedDate.year, changeDateMode == ChangeDateMode.monthly? pickedDate.month - 1 : pickedDate.month, changeDateMode == ChangeDateMode.daily? pickedDate.day - 1 : changeDateMode == ChangeDateMode.weekly? pickedDate.day - 7 : pickedDate.day, pickedDate.hour,pickedDate.minute,pickedDate.second);
    // DateTime endDateCompare = DateTime(endDate.year, changeDateMode == ChangeDateMode.monthly? endDate.month - 1 : endDate.month, changeDateMode == ChangeDateMode.daily? endDate.day - 1 : changeDateMode == ChangeDateMode.weekly? endDate.day - 7 : endDate.day, endDate.hour,endDate.minute,endDate.second);
    // final appUsageInfoCompare = await _providerContainer.read(appUsageProvider.notifier).getUsageData(startDateCompare, endDateCompare);
    // totalUsageTimeToCompare = appUsageInfoCompare.fold(
    //   const Duration(minutes: 0), (Duration? a, AppUsageData b) => a! + b.usageTime,
    // );
    //////////////////////////////////
    print(pickedDate);
    print(endDate);
    print('-----------------------------');
    // appUsageInfo = appUsageInfo.where((element)  => element.usageTime.inMinutes != 0).toList();
    // appUsageInfo.sort((a, b) => b.usageTime.compareTo(a.usageTime));
    // totalUsageTime = appUsageInfo.fold(
    //   const Duration(minutes: 0), (Duration? a, AppUsageData b) => a! + b.usageTime,
    // );
    state = UsageUpdated();
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
    if(pickedDateTemp == null)
    {
      return ;
    }
    pickedDate = pickedDateTemp;
    state = DatePicked();
    await _getUsageData();
  }

  Future<String> getCompareText(DateTime myDate, ChangeDateMode changeDateMode) async
  {
    ///////////////////////////////////
    DateTime endDate = changeDateMode == ChangeDateMode.daily? DateTime(myDate.year, myDate.month, myDate.day, 23, 59, 59) : changeDateMode == ChangeDateMode.weekly? myDate.add(const Duration(days: 7)): DateTime(myDate.year, myDate.month + 1, 1); 
    DateTime startDateCompare = DateTime(myDate.year, changeDateMode == ChangeDateMode.monthly? myDate.month - 1 : myDate.month, changeDateMode == ChangeDateMode.daily? myDate.day - 1 : changeDateMode == ChangeDateMode.weekly? myDate.day - 7 : myDate.day, myDate.hour,myDate.minute,myDate.second);
    DateTime endDateCompare = DateTime(endDate.year, changeDateMode == ChangeDateMode.monthly? endDate.month - 1 : endDate.month, changeDateMode == ChangeDateMode.daily? endDate.day - 1 : changeDateMode == ChangeDateMode.weekly? endDate.day - 7 : endDate.day, endDate.hour,endDate.minute,endDate.second);
    
    List<AppUsageData>? infoCompare = appUsageInfoMap[startDateCompare]?[changeDateMode];
    if(infoCompare == null)
    {
      List<AppUsageData> appInfoTemp = await _providerContainer.read(appUsageProvider.notifier).getUsageData(startDateCompare, endDateCompare); 
      appInfoTemp = appInfoTemp.where((element)  => element.usageTime.inMinutes != 0).toList();
      appInfoTemp.sort((a, b) => b.usageTime.compareTo(a.usageTime));
      appUsageInfoMap[startDateCompare] ??= {};
      appUsageInfoMap[startDateCompare]![changeDateMode] = [...appInfoTemp];
    }
    final totalUsageTimeToCompare = appUsageInfoMap[startDateCompare]![changeDateMode]!.fold(
      const Duration(minutes: 0), (Duration? a, AppUsageData b) => a! + b.usageTime,
    );
    final totalUsageTimePicked = appUsageInfoMap[myDate]![changeDateMode]!.fold(
      const Duration(minutes: 0), (Duration? a, AppUsageData b) => a! + b.usageTime,
    );
    //////////////////////////////////
    String finalPart = changeDateMode == ChangeDateMode.daily? 'yesterday' : changeDateMode == ChangeDateMode.weekly? 'last week' : 'last month';
    final diff = totalUsageTimePicked.inHours - totalUsageTimeToCompare.inHours;
    if(diff == 0)
    {
      return 'same Amount of time as $finalPart';
    }else if (diff > 0)
    {
      return '$diff hours more than $finalPart';
    }else{
      return '${-1 *diff} hours less than $finalPart';
    }
  }
  void toggleDateMode(ChangeDateMode mode)
  {
    if(changeDateMode != mode)
    {
      changeDateMode = mode;
      _getUsageData();
      state = DateModeChanged();
    }
  }

  Duration getTotalUsage(List<AppUsageData> listData)
  {
    return listData.fold(
      const Duration(minutes: 0), (Duration? a, AppUsageData b) => a! + b.usageTime,
    );
  }
}

final homeProvider = StateNotifierProvider<HomeViewModel, HomeState>(
    (ref) => getIt<HomeViewModel>());

sealed class HomeState {}

class InitialState extends HomeState {}

// class LoadingState extends HomeState {}

class DatePicked extends HomeState {}

class UsageUpdated extends HomeState {}

class DateModeChanged extends HomeState {}
class SuccessState extends HomeState {
  final User user;
  SuccessState(this.user);
}

class ErrorState extends HomeState {
  final Exception error;
  ErrorState(this.error);
}
