import 'recommended_app.dart';

class RecommendationResponse {
  RecommendedApp? recommendedApp;

  RecommendationResponse({this.recommendedApp});

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      recommendedApp: json['recommended_app'] == null
          ? null
          : RecommendedApp.fromJson(
              json['recommended_app'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'recommended_app': recommendedApp?.toJson(),
      };
}
