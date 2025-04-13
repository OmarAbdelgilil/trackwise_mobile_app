import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/scores.dart';
import 'package:track_wise_mobile_app/features/friends/domain/repos/friends_repo.dart';

@injectable
class GetScoresUseCase {
  final FriendsRepo _friendsRepo;
  GetScoresUseCase(this._friendsRepo);
  Future<Result<Scores>> getScores() {
    return _friendsRepo.getScores();
  }
}
