import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/profile/data/models/response/user_tags/user_tags.dart';

abstract class OnlineDataSource {
  Future<Result<UserTags>> getuserTags();
}
