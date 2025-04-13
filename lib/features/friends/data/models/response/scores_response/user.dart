class User {
  String? name;
  String? email;
  double? score;
  int? steps;
  double? usage;

  User({this.name, this.email, this.score, this.steps, this.usage});

  factory User.fromJson(Map<String, dynamic> json) => User(
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
