import 'user.dart';

class SearchEmailResponse {
  User? user;

  SearchEmailResponse({this.user});

  factory SearchEmailResponse.fromJson(Map<String, dynamic> json) {
    return SearchEmailResponse(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user?.toJson(),
      };
}
