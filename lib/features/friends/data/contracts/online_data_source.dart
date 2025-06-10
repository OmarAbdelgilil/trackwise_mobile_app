import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/friend_user.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/scores.dart';

abstract class OnlineDataSource {
  Future<Result<List<FriendUser>>> searchByEmail(String email, String token);
  Future<Result<Scores>> getScores(String token, {String? date});
  Future<Result<String>> sendFriendRequest(String email, String token);
  Future<Result<List<FriendUser>>> getFriendRequests(String token);
  Future<Result<String>> acceptFriendRequest(String email, String token);
  Future<Result<String>> rejectFriendRequest(String email, String token);
  Future<Result<void>> unFriend(String email, String token);
}
