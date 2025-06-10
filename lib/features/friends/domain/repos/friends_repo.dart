import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/friend_user.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/scores.dart';

abstract class FriendsRepo {
  Future<Result<List<FriendUser>>> searchByEmail(String email);
  Future<Result<Scores>> getScores({String? date});
  Future<Result<String>> sendFriendRequest(String email);
  Future<Result<List<FriendUser>>> getFriendRequest();
  Future<Result<String>> acceptFriendRequest(String email);
  Future<Result<String>> rejectFriendRequest(String email);
  Future<Result<void>> unFriend(String email);
}
