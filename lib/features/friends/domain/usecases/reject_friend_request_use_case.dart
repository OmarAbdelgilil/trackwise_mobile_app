import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/domain/repos/friends_repo.dart';

@injectable
class RejectFriendRequestUseCase {
  final FriendsRepo _friendsRepo;
  RejectFriendRequestUseCase(this._friendsRepo);
  Future<Result<String>> rejectFriendRequest(String email) async {
    return await _friendsRepo.rejectFriendRequest(email);
  }
}
