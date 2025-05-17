class SendFriendRequestResponse {
  String? message;

  SendFriendRequestResponse({this.message});

  factory SendFriendRequestResponse.fromJson(Map<String, dynamic> json) {
    return SendFriendRequestResponse(
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
