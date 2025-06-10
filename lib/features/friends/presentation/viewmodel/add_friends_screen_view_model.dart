import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/friend_user.dart';
import 'package:track_wise_mobile_app/features/friends/domain/usecases/search_by_email_use_case.dart';
import 'package:track_wise_mobile_app/features/friends/domain/usecases/send_friend_request_use_case.dart';

@injectable
class AddFriendsScreenViewModel extends Cubit<FriendsState> {
  final SearchByEmailUseCase _searchByEmailUseCase;
  final SendFriendRequestUseCase _sendFriendRequestUseCase;
  AddFriendsScreenViewModel(
      this._searchByEmailUseCase, this._sendFriendRequestUseCase)
      : super(FriendsInitial());

  void searchUserByEmail(String email) async {
    emit(FriendsLoading());
    final result = await _searchByEmailUseCase.searchByEmail(email);
    switch (result) {
      case Success<List<FriendUser>>():
        emit(FriendsLoaded(result.data!));
      case Fail<List<FriendUser>>():
        emit(FriendsError(result.exception!));
    }
  }

  Future<void> sendFriendRequest(FriendUser user) async {
    emit(FriendRequestLoading());
    final result =
        await _sendFriendRequestUseCase.sendFriendRequest(user.email);
    switch (result) {
      case Success<String>():
        emit(FriendRequesSuccess(result.data!));
      case Fail<String>():
        emit(FriendsRequesError(result.exception!));
    }
  }
}

abstract class FriendsState {}

class FriendsInitial extends FriendsState {}

class FriendsLoading extends FriendsState {}

class FriendRequestLoading extends FriendsState {}

class FriendRequesSuccess extends FriendsState {
  String message;
  FriendRequesSuccess(this.message);
}

class FriendsRequesError extends FriendsState {
  final Exception message;

  FriendsRequesError(this.message);
}

class FriendsLoaded extends FriendsState {
  final List<FriendUser> users;

  FriendsLoaded(this.users);
}

class FriendsError extends FriendsState {
  final Exception message;

  FriendsError(this.message);
}
