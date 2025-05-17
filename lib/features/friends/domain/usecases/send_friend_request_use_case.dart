import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/domain/repos/friends_repo.dart';

@injectable
class SendFriendRequestUseCase {
  final FriendsRepo _friendsRepo;
  SendFriendRequestUseCase(this._friendsRepo);
  Future<Result<String>> sendFriendRequest(String email) async {
    return await _friendsRepo.sendFriendRequest(email);
  }
}
