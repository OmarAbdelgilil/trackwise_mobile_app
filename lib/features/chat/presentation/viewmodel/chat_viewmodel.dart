import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/friend_score.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/scores.dart';
import 'package:track_wise_mobile_app/features/friends/domain/usecases/get_scores_use_case.dart';

@injectable
class ChatViewmodel extends StateNotifier<ChatState> {
  final GetScoresUseCase _getScoresUseCase;
  List<FriendScore>? friends;
  
  ChatViewmodel(this._getScoresUseCase) : super(InitialState()) {
   getFriends();
  }
  Future<void> getFriends() async {
    state = LoadingState();
    final friendsRes = await _getScoresUseCase.getScores();
    switch (friendsRes) {
      case Success<Scores>():
        friends = friendsRes.data!.scoresList;
        friends!.removeWhere((element) => element.me);
        state = SuccessState();
        break;
      case Fail<Scores>():
        state = ErrorState();
        break;
    }
  }
}

final chatViewmodelProvider = StateNotifierProvider<ChatViewmodel, ChatState>(
    (ref) => getIt<ChatViewmodel>());

sealed class ChatState {}

class InitialState extends ChatState {}

class LoadingState extends ChatState {}

class SuccessState extends ChatState {}

class ErrorState extends ChatState {}
