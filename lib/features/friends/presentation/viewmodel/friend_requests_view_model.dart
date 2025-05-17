import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/friend_user.dart';
import 'package:track_wise_mobile_app/features/friends/domain/usecases/accept_friend_request_use_case.dart';

import 'package:track_wise_mobile_app/features/friends/domain/usecases/get_friend_requests_use_case.dart';
import 'package:track_wise_mobile_app/features/friends/domain/usecases/reject_friend_request_use_case.dart';

@injectable
class FriendRequestsViewModel extends Cubit<FriendsStates> {
  final GetFriendRequestsUseCase _getFriendRequestsUseCase;
  final AcceptFriendRequestUseCase _acceptFriendRequestUseCase;
  final RejectFriendRequestUseCase _rejectFriendRequestUseCase;
  List<FriendUser> requests = [];
  FriendRequestsViewModel(this._getFriendRequestsUseCase,
      this._acceptFriendRequestUseCase, this._rejectFriendRequestUseCase)
      : super(FriendsInitial());

  void getScores() async {
    emit(ScoresLoading());
    final requestsResult = await _getFriendRequestsUseCase.etFriendRequests();

    switch (requestsResult) {
      case Success<List<FriendUser>>():
        requests = requestsResult.data!;
        emit(ScoresLoaded());
      case Fail<List<FriendUser>>():
        emit(FriendsError(requestsResult.exception!));
    }
  }

  void acceptFriendRequest(FriendUser user) async {
    emit(ScoresLoading());
    final result =
        await _acceptFriendRequestUseCase.acceptFriendRequest(user.email);

    switch (result) {
      case Success<String>():
        requests.remove(user);
        emit(FriendAccRejSuccess(result.data!));

      case Fail<String>():
        emit(FriendAccRejError(result.exception!));
    }
  }

  void rejectFriendRequest(FriendUser user) async {
    emit(ScoresLoading());
    final result =
        await _rejectFriendRequestUseCase.rejectFriendRequest(user.email);

    switch (result) {
      case Success<String>():
        requests.remove(user);
        emit(FriendAccRejSuccess(result.data!));

      case Fail<String>():
        emit(FriendAccRejError(result.exception!));
    }
  }
}

abstract class FriendsStates {}

class FriendsInitial extends FriendsStates {}

class ScoresLoading extends FriendsStates {}

class ScoresLoaded extends FriendsStates {}

class FriendAccRejSuccess extends FriendsStates {
  String message;
  FriendAccRejSuccess(this.message);
}

class FriendAccRejError extends FriendsStates {
  final Exception message;

  FriendAccRejError(this.message);
}

class FriendsError extends FriendsStates {
  final Exception message;

  FriendsError(this.message);
}
