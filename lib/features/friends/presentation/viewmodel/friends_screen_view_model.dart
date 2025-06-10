import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/scores.dart';
import 'package:track_wise_mobile_app/features/friends/domain/usecases/get_scores_use_case.dart';
import 'package:track_wise_mobile_app/features/friends/domain/usecases/un_friend_use_case.dart';

@injectable
class FriendsScreenViewModel extends StateNotifier<FriendsStates> {
  final GetScoresUseCase _getScoresUseCase;
  final UnFriendUseCase _unFriendUseCase;
  String first = "NA";
  String second = "NA";
  String third = "NA";
  DateTime pickedDate = DateTime.now();
  Map<String, Result<Scores>> prevResults = {};
  FriendsScreenViewModel(this._getScoresUseCase, this._unFriendUseCase)
      : super(FriendsInitial());

  void getScores({bool refresh = false}) async {
    state = ScoresLoading();
    Result<Scores> result;
    final formDate = '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}';
    if (prevResults.containsKey(formDate) && !refresh) {
      result = prevResults[formDate]!;
    } else {
      result = await _getScoresUseCase.getScores(
          date: '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}');
    }

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
        prevResults[
                '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}'] =
            result;

        state = ScoresLoaded(result.data!);
      case Fail<Scores>():
        state = FriendsError(result.exception!);
    }
  }

  Future<void> unFriend(String email) async {
    state = ScoresLoading();
    final result = await _unFriendUseCase.unFriend(email);
    switch (result) {
      case Success<void>():
        prevResults = {};
        getScores();
      case Fail<void>():
        state = FriendsError(result.exception!);
    }
  }

  Future<void> openCalender(BuildContext context) async {
    final now = DateTime.now();
    DateTime? pickedDateTemp = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: now.subtract(const Duration(days: 365 * 3)),
      lastDate: now,
    );

    if (pickedDateTemp == null) {
      return;
    }

    pickedDate = pickedDateTemp;
    getScores();
  }
}

final friendsViewModelProvider =
    StateNotifierProvider<FriendsScreenViewModel, FriendsStates>(
        (ref) => getIt<FriendsScreenViewModel>()..getScores());

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
