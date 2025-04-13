import 'friends_score.dart';
import 'user.dart';

class ScoresResponse {
  User? user;
  List<FriendsScore>? friendsScores;

  ScoresResponse({this.user, this.friendsScores});

  factory ScoresResponse.fromJson(Map<String, dynamic> json) {
    return ScoresResponse(
      user: json['User'] == null
          ? null
          : User.fromJson(json['User'] as Map<String, dynamic>),
      friendsScores: (json['friendsScores'] as List<dynamic>?)
          ?.map((e) => FriendsScore.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'User': user?.toJson(),
        'friendsScores': friendsScores?.map((e) => e.toJson()).toList(),
      };
}
