class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone});

  factory User.fromJson(Map<String, dynamic> json) => User(
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: (json['phoneNumber'] as int).toString(),
      id: json['id'] as String);
}
