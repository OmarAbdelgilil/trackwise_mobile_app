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
  Future<Result<FriendUser>> searchByEmail(String email) {
    return executeApi(
      () async {
        final result = await _apiManager.searchByEmail(email);
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
}
