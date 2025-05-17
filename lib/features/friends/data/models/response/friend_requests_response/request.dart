class Request {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;

  Request({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        id: json['_id'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
      };
}
