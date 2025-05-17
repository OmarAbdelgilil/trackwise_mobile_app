import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final SharedPreferences _prefs;
  FriendsRepoImpl(this._onlineDataSource, this._prefs);
  @override
  Future<Result<FriendUser>> searchByEmail(String email) async {
    return await _onlineDataSource.searchByEmail(email);
  }

  @override
  Future<Result<Scores>> getScores() {
    final token = _providerContainer.read(userProvider.notifier).token;
    return _onlineDataSource.getScores(token!);
  }

  @override
  Future<Result<String>> sendFriendRequest(String email) async {
    return await _onlineDataSource.sendFriendRequest(
        email, _prefs.getString("token")!);
  }

  @override
  Future<Result<List<FriendUser>>> getFriendRequest() async {
    return await _onlineDataSource
        .getFriendRequests(_prefs.getString("token")!);
  }

  @override
  Future<Result<String>> acceptFriendRequest(String email) async {
    return await _onlineDataSource.acceptFriendRequest(
        email, _prefs.getString("token")!);
  }

  @override
  Future<Result<String>> rejectFriendRequest(String email) async {
    return await _onlineDataSource.rejectFriendRequest(
        email, _prefs.getString("token")!);
  }
}
