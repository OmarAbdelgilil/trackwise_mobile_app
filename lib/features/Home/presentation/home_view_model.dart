import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/core/provider/usage_provider.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';

@injectable
class HomeViewModel extends StateNotifier<HomeState> {
  late final ProviderContainer _providerContainer;
  late DateTime pickedDate;
  late Duration totalUsageTime;
  late List<AppUsageInfo> appUsageInfo;

  HomeViewModel() : super(InitialState()) {
    _providerContainer = ProviderContainer();
    final now = DateTime.now();
    pickedDate = DateTime(now.year, now.month, now.day);
    _getUsageData(now);

  }
  Future<void> _getUsageData(DateTime date) async
  {
    state = LoadingState();
    appUsageInfo = await _providerContainer.read(appUsageProvider.notifier).getUsageData(pickedDate.subtract(const Duration(days: 1)), pickedDate);
    totalUsageTime = appUsageInfo.fold(const Duration(minutes: 0), (Duration a,AppUsageInfo b) => a + b.usage,);
    state = UsageUpdated();
  }
  Future<void> openCalender(BuildContext context) async
  {
    final now = DateTime.now();
    pickedDate = (await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: now.subtract(const Duration(days: 365 * 3)),
      lastDate: now,
    ))!;
    state = DatePicked();
    await _getUsageData(pickedDate);
  }
}

final homeProvider = StateNotifierProvider<HomeViewModel, HomeState>(
    (ref) => getIt<HomeViewModel>());

sealed class HomeState {}

class InitialState extends HomeState {}

class LoadingState extends HomeState {}

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
