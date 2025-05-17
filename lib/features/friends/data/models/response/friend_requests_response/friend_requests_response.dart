import 'request.dart';

class FriendRequestsResponse {
  List<Request>? requests;

  FriendRequestsResponse({this.requests});

  factory FriendRequestsResponse.fromJson(Map<String, dynamic> json) {
    return FriendRequestsResponse(
      requests: (json['requests'] as List<dynamic>?)
          ?.map((e) => Request.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'requests': requests?.map((e) => e.toJson()).toList(),
      };
}
