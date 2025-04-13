import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/scores.dart';
import 'package:track_wise_mobile_app/features/friends/domain/usecases/get_scores_use_case.dart';

@injectable
class FriendsScreenViewModel extends Cubit<FriendsStates> {
  final GetScoresUseCase _getScoresUseCase;
  String first = "NA";
  String second = "NA";
  String third = "NA";
  FriendsScreenViewModel(this._getScoresUseCase) : super(FriendsInitial());

  void getScores() async {
    emit(ScoresLoading());
    final result = await _getScoresUseCase.getScores();
    switch (result) {
      case Success<Scores>():
        if (result.data!.scoresList.length >= 3) {
          first = result.data!.scoresList[0].name;
          second = result.data!.scoresList[1].name;
          third = result.data!.scoresList[2].name;
        } else if (result.data!.scoresList.length == 2) {
          first = result.data!.scoresList[0].name;
          second = result.data!.scoresList[1].name;
        } else if (result.data!.scoresList.length == 1) {
          first = result.data!.scoresList[0].name;
        }
        emit(ScoresLoaded(result.data!));
      case Fail<Scores>():
        emit(FriendsError(result.exception!));
    }
  }
}

abstract class FriendsStates {}

class FriendsInitial extends FriendsStates {}

class ScoresLoading extends FriendsStates {}

class ScoresLoaded extends FriendsStates {
  final Scores scores;

  ScoresLoaded(this.scores);
}

class FriendsError extends FriendsStates {
  final Exception message;

  FriendsError(this.message);
}
