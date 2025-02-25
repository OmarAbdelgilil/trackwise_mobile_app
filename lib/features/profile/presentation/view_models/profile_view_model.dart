import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/use_cases/logout_use_case.dart';

@injectable
class ProfileViewModel extends StateNotifier<ProfileState> {
  final LogoutUseCase _logoutUseCase;
  ProfileViewModel(this._logoutUseCase) : super(InitialState());
  Future<void> logout() async {
    await _logoutUseCase.logout();
  }
}

final profileProvider = StateNotifierProvider<ProfileViewModel, ProfileState>(
    (ref) => getIt<ProfileViewModel>());

sealed class ProfileState {}

class InitialState extends ProfileState {}

class HomeLoadingState extends ProfileState {}

class SuccessState extends ProfileState {}

class ErrorState extends ProfileState {}
