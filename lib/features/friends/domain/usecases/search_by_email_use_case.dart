import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/friend_user.dart';
import 'package:track_wise_mobile_app/features/friends/domain/repos/friends_repo.dart';

@injectable
class SearchByEmailUseCase {
  final FriendsRepo _friendsRepo;
  SearchByEmailUseCase(this._friendsRepo);
  Future<Result<List<FriendUser>>> searchByEmail(String email) {
    return _friendsRepo.searchByEmail(email);
  }
}
