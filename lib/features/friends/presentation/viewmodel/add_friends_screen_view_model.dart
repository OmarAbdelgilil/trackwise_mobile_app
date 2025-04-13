import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/friend_user.dart';
import 'package:track_wise_mobile_app/features/friends/domain/usecases/search_by_email_use_case.dart';

@injectable
class AddFriendsScreenViewModel extends Cubit<FriendsState> {
  final SearchByEmailUseCase _searchByEmailUseCase;

  AddFriendsScreenViewModel(this._searchByEmailUseCase)
      : super(FriendsInitial());

  void searchUserByEmail(String email) async {
    emit(FriendsLoading());
    final result = await _searchByEmailUseCase.searchByEmail(email);
    switch (result) {
      case Success<FriendUser>():
        emit(FriendsLoaded(result.data!));
      case Fail<FriendUser>():
        emit(FriendsError(result.exception!));
    }
  }
}

abstract class FriendsState {}

class FriendsInitial extends FriendsState {}

class FriendsLoading extends FriendsState {}

class FriendsLoaded extends FriendsState {
  final FriendUser user;

  FriendsLoaded(this.user);
}

class FriendsError extends FriendsState {
  final Exception message;

  FriendsError(this.message);
}
