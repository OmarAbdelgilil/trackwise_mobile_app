class FriendsScore {
  String? name;
  String? email;
  double? score;
  int? steps;
  double? usage;

  FriendsScore({this.name, this.email, this.score, this.steps, this.usage});

  factory FriendsScore.fromJson(Map<String, dynamic> json) => FriendsScore(
        name: json['name'] as String?,
        email: json['email'] as String?,
        score: (json['score'] as num?)?.toDouble(),
        steps: json['steps'] as int?,
        usage: (json['usage'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'score': score,
        'steps': steps,
        'usage': usage,
      };
}
