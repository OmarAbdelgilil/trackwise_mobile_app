import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/api/api_execution.dart';
import 'package:track_wise_mobile_app/core/api/api_manager.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/data/contracts/online_data_source.dart';
import 'package:track_wise_mobile_app/features/friends/data/dtos/scores_dto.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/friend_user.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/scores.dart';

@Injectable(as: OnlineDataSource)
class OnlineDataSourcesImpl extends OnlineDataSource {
  ApiManager _apiManager;
  OnlineDataSourcesImpl(this._apiManager);
  @override
  Future<Result<FriendUser>> searchByEmail(String email, String token) {
    return executeApi(
      () async {
        final result = await _apiManager.searchByEmail(email, token);

        return FriendUser.fromJson(result.user!.toJson());
      },
    );
  }

  @override
  Future<Result<Scores>> getScores(String token) {
    return executeApi(() async {
      final result = await _apiManager.getScores(token);
      final Scores scores =
          ScoresDto(friendsScores: result.friendsScores!, user: result.user!)
              .toScores();
      return scores;
    });
  }

  @override
  Future<Result<String>> sendFriendRequest(String email, String token) {
    return executeApi(() async {
      final result = await _apiManager.sendFriendRequest(email, token);
      final String message = result.message!;
      return message;
    });
  }

  @override
  Future<Result<List<FriendUser>>> getFriendRequests(String token) {
    return executeApi(() async {
      final result = await _apiManager.getFriendRequests(token);
      final resutList = result.requests!
          .map(
            (e) => FriendUser.fromJson(e.toJson()),
          )
          .toList();

      return resutList;
    });
  }

  @override
  Future<Result<String>> acceptFriendRequest(String email, String token) {
    return executeApi(() async {
      final result = await _apiManager.acceptFriendRequest(email, token);
      final String message = result.message!;
      return message;
    });
  }

  @override
  Future<Result<String>> rejectFriendRequest(String email, String token) {
    return executeApi(() async {
      final result = await _apiManager.rejectFriendRequest(email, token);
      final String message = result.message!;
      return message;
    });
  }
}
