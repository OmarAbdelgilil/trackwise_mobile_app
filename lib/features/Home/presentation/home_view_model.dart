import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/core/provider/usage_provider.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';

@injectable
class HomeViewModel extends StateNotifier<HomeState> {
  late final ProviderContainer _providerContainer;
  late DateTime pickedDate;
  Duration? totalUsageTime;
  late List<AppUsageData> appUsageInfo;

  HomeViewModel() : super(InitialState()) {
    _providerContainer = ProviderContainer();
    final now = DateTime.now();
    pickedDate = DateTime(now.year, now.month, now.day);
    _getUsageData();
  }
  Future<void> _getUsageData() async {
    //to load only the first time
    //state = LoadingState();
    appUsageInfo = await _providerContainer
        .read(appUsageProvider.notifier)
        .getUsageData(
            pickedDate,
            DateTime(
                pickedDate.year, pickedDate.month, pickedDate.day, 23, 59, 59));
    appUsageInfo = appUsageInfo.where((element)  => element.usageTime.inMinutes != 0).toList();
    appUsageInfo.sort((a, b) => b.usageTime.compareTo(a.usageTime));
    totalUsageTime = appUsageInfo.fold(
      const Duration(minutes: 0),
      (Duration? a, AppUsageData b) => a! + b.usageTime,
    );
    state = UsageUpdated();
  }

  Future<void> openCalender(BuildContext context) async {
    final now = DateTime.now();
    pickedDate = (await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: now.subtract(const Duration(days: 365 * 3)),
      lastDate: now,
    ))!;
    state = DatePicked();
    await _getUsageData();
  }
}

final homeProvider = StateNotifierProvider<HomeViewModel, HomeState>(
    (ref) => getIt<HomeViewModel>());

sealed class HomeState {}

class InitialState extends HomeState {}

// class LoadingState extends HomeState {}

class DatePicked extends HomeState {}

class UsageUpdated extends HomeState {}

class SuccessState extends HomeState {
  final User user;
  SuccessState(this.user);
}

class ErrorState extends HomeState {
  final Exception error;
  ErrorState(this.error);
}
