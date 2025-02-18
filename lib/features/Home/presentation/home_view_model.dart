import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';

@injectable
class HomeViewModel extends StateNotifier<HomeState> {
  
  late DateTime pickedDate;

  HomeViewModel() : super(InitialState()) {
    final now = DateTime.now();
    pickedDate = DateTime(now.year, now.month, now.day);
  }
  Future<void> openCalender(BuildContext context) async
  {
    final now = DateTime.now();
    pickedDate = (await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365 * 3)),
      lastDate: now,
    ))!; 
    state = DatePicked();
  }
}

final homeProvider = StateNotifierProvider<HomeViewModel, HomeState>(
    (ref) => getIt<HomeViewModel>());

sealed class HomeState {}

class InitialState extends HomeState {}

class LoadingState extends HomeState {}

class DatePicked extends HomeState {}

class SuccessState extends HomeState {
  final User user;
  SuccessState(this.user);
}

class ErrorState extends HomeState {
  final Exception error;
  ErrorState(this.error);
}
