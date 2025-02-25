class RegisterRequest {
	String? email;
	String? firstName;
	String? lastName;
	String? phoneNumber;
	String? password;
	String? confirmPassword;

	RegisterRequest({this.email,this.firstName,this.lastName,this.phoneNumber, this.password, this.confirmPassword});

	factory RegisterRequest.fromJson(Map<String, dynamic> json) => RegisterRequest(
				email: json['email'] as String?,
				firstName: json['firstName'] as String?,
				lastName: json['firstName'] as String?,
				phoneNumber: json['phoneNumber'] as String?,
				password: json['password'] as String?,
				confirmPassword: json['confirmPassword'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'email': email,
				'firstName': firstName,
				'lastName': lastName,
				'phoneNumber': phoneNumber,
        'password': password,
				'confirmPassword': confirmPassword,
			};
}
