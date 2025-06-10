class VerifyEmailRequest {
  String? email;

  VerifyEmailRequest({this.email});

  factory VerifyEmailRequest.fromJson(Map<String, dynamic> json) {
    return VerifyEmailRequest(
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
      };
}
