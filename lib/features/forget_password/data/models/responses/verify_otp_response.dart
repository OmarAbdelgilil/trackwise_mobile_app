class VerifyOtpResponse {
  String? message;
  String? resetToken;

  VerifyOtpResponse({this.message, this.resetToken});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      message: json['message'] as String?,
      resetToken: json['resetToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'resetToken': resetToken,
      };
}
