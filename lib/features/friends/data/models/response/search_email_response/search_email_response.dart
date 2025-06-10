import 'user.dart';

class SearchEmailResponse {
  List<User?> users;

  SearchEmailResponse({required this.users});

  factory SearchEmailResponse.fromJson(Map<String, dynamic> json) {
    return SearchEmailResponse(
      users: (json['user'] as List<dynamic>?)
              ?.map((e) =>
                  e == null ? null : User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
