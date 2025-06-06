import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/Notifications/data/response/recommendation_response/recommendation_response.dart';

abstract class OnlineDataSource {
  Future<Result<RecommendationResponse>> getRecommendation();
}
