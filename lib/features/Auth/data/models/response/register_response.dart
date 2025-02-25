class RegisterResponse {
  String? message;

	RegisterResponse({this.message});

	factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
				message: json['message'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'message': message,
			};
}