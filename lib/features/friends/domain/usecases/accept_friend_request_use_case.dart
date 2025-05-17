import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/domain/repos/friends_repo.dart';

@injectable
class AcceptFriendRequestUseCase {
  final FriendsRepo _friendsRepo;
  AcceptFriendRequestUseCase(this._friendsRepo);
  Future<Result<String>> acceptFriendRequest(String email) async {
    return await _friendsRepo.acceptFriendRequest(email);
  }
}
