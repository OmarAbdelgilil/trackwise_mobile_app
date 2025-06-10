import 'tag.dart';

class UserTags {
  String? message;
  List<Tag>? tags;

  UserTags({this.message, this.tags});

  factory UserTags.fromJson(Map<String, dynamic> json) => UserTags(
        message: json['message'] as String?,
        tags: (json['tags'] as List<dynamic>?)
            ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'tags': tags?.map((e) => e.toJson()).toList(),
      };
}
