import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/core/provider/user_provider.dart';
import 'package:track_wise_mobile_app/features/friends/data/contracts/online_data_source.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/friend_user.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/scores.dart';
import 'package:track_wise_mobile_app/features/friends/domain/repos/friends_repo.dart';
import 'package:track_wise_mobile_app/main.dart';

@Injectable(as: FriendsRepo)
class FriendsRepoImpl implements FriendsRepo {
  final OnlineDataSource _onlineDataSource;
  final ProviderContainer _providerContainer = providerContainer;
  FriendsRepoImpl(this._onlineDataSource);
  @override
  Future<Result<FriendUser>> searchByEmail(String email) async {
    return await _onlineDataSource.searchByEmail(email);
  }

  @override
  Future<Result<Scores>> getScores() {
    final token = _providerContainer.read(userProvider.notifier).token;
    return _onlineDataSource.getScores(token!);
  }
}
