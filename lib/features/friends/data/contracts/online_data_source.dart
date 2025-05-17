import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/friend_user.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/scores.dart';

abstract class OnlineDataSource {
  Future<Result<FriendUser>> searchByEmail(String email);
  Future<Result<Scores>> getScores(String token);
  Future<Result<String>> sendFriendRequest(String email, String token);
  Future<Result<List<FriendUser>>> getFriendRequests(String token);
  Future<Result<String>> acceptFriendRequest(String email, String token);
  Future<Result<String>> rejectFriendRequest(String email, String token);
}
