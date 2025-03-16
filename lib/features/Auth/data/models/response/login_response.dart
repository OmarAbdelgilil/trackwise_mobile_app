class LoginResponse {
  String? message;
  String? token;
  Map<String, dynamic>? usage;
  Map<String, dynamic>? steps;

  LoginResponse({this.message, this.token, this.usage, this.steps});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        message: json['message'] as String?,
        token: json['token'] as String?,
        usage: json['usage'] as Map<String, dynamic>?,
        steps: json['steps'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() =>
      {'message': message, 'token': token, 'usage': usage, 'steps': steps};
}
