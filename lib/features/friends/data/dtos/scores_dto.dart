import 'package:track_wise_mobile_app/features/friends/data/models/response/scores_response/friends_score.dart';
import 'package:track_wise_mobile_app/features/friends/data/models/response/scores_response/user.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/friend_score.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/scores.dart';

class ScoresDto {
  User user;
  List<FriendsScore> friendsScores;
  ScoresDto({required this.friendsScores, required this.user});
  Scores toScores() {
    final List<FriendScore> scores = friendsScores.map(
      (e) {
        return FriendScore(
            score: e.score!,
            email: e.email!,
            name: e.name!,
            steps: e.steps!,
            usage: e.usage!);
      },
    ).toList();
    scores.add(FriendScore(
        score: user.score!,
        email: user.email!,
        name: user.name!,
        steps: user.steps!,
        usage: user.usage!,
        me: true));
    scores.sort((a, b) => b.score.compareTo(a.score));

    return Scores(scoresList: scores);
  }
}
