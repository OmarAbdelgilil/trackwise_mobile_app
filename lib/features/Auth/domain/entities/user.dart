class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json['email'] as String,
        name: json['name'] as String,
      );
}
