import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/use_cases/logout_use_case.dart';
import 'package:track_wise_mobile_app/features/profile/data/contracts/online_data_source.dart';
import 'package:track_wise_mobile_app/features/profile/data/models/response/user_tags/user_tags.dart';

@injectable
class ProfileViewModel extends StateNotifier<ProfileState> {
  final LogoutUseCase _logoutUseCase;
  final OnlineDataSource _onlineDataSource;
  ProfileViewModel(this._logoutUseCase, this._onlineDataSource)
      : super(InitialState());

  Future<void> logout() async {
    await _logoutUseCase.logout();
  }

  Future<void> getTags() async {
    final result = await _onlineDataSource.getuserTags();
    switch (result) {
      case Success<UserTags>():
        state = TagsLoaded(result.data!);
      case Fail<UserTags>():
        return;
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileViewModel, ProfileState>(
    (ref) => getIt<ProfileViewModel>()..getTags());

sealed class ProfileState {}

class InitialState extends ProfileState {}

class HomeLoadingState extends ProfileState {}

class TagsLoading extends ProfileState {}

class TagsLoaded extends ProfileState {
  final UserTags tags;
  TagsLoaded(this.tags);
}

class SuccessState extends ProfileState {}

class ErrorState extends ProfileState {}
