import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/domain/repos/friends_repo.dart';

@injectable
class UnFriendUseCase {
  final FriendsRepo _friendsRepo;
  UnFriendUseCase(this._friendsRepo);
  Future<Result<void>> unFriend(String email) {
    return _friendsRepo.unFriend(email);
  }
}
