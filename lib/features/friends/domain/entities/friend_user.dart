class FriendUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;

  FriendUser(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone});

  factory FriendUser.fromJson(Map<String, dynamic> json) => FriendUser(
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phoneNumber'] as String,
      id: json['_id'] as String);
}
