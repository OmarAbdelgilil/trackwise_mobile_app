class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      id: json['id'] as String);
}
