import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:track_wise_mobile_app/core/api/api_constants.dart';
import 'package:track_wise_mobile_app/features/Auth/data/models/request/login_request.dart';
import 'package:track_wise_mobile_app/features/Auth/data/models/request/register_request.dart';
import 'package:track_wise_mobile_app/features/Auth/data/models/response/login_response.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:track_wise_mobile_app/features/Auth/data/models/response/register_response.dart';
import 'package:track_wise_mobile_app/features/Home/data/models/app_usage_data.dart';
import 'package:track_wise_mobile_app/features/Notifications/data/response/recommendation_response/recommendation_response.dart';
import 'package:track_wise_mobile_app/features/friends/data/models/response/friend_requests_response/friend_requests_response.dart';
import 'package:track_wise_mobile_app/features/friends/data/models/response/scores_response/scores_response.dart';
import 'package:track_wise_mobile_app/features/friends/data/models/response/search_email_response/search_email_response.dart';
import 'package:track_wise_mobile_app/features/friends/data/models/response/send_friend_request_response.dart';

@singleton
@injectable
class ApiManager {
  late Dio _dio;
  ApiManager() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
    ));
    if (!kReleaseMode) {
      // its debug mode so print app logs
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }
  }

  Future<LoginResponse> login(LoginRequest request) async {
    var response =
        await _dio.post(ApiConstants.loginPath, data: request.toJson());
    var authResponse = LoginResponse.fromJson(response.data);
    return authResponse;
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    var response =
        await _dio.post(ApiConstants.signupPath, data: request.toJson());
    var authResponse = RegisterResponse.fromJson(response.data);
    return authResponse;
  }

  void setUsageHistory(
      Map<DateTime, List<AppUsageData>> data, String token) async {
    await _dio.post(ApiConstants.addUsage,
        data: {"usage": AppUsageData.toRequest(data)},
        options: Options(headers: {"Authorization": "Bearer $token"}));
  }

  void setStepsHistory(Map<String, int> data, String token) async {
    await _dio.post(ApiConstants.addSteps,
        data: {"steps": data},
        options: Options(headers: {"Authorization": "Bearer $token"}));
  }

  Future<SearchEmailResponse> searchByEmail(String email, String token) async {
    final response = await _dio.post(ApiConstants.searchByEmail,
        data: {"email": email},
        options: Options(headers: {"Authorization": "Bearer $token"}));
    return SearchEmailResponse.fromJson(response.data);
  }

  Future<ScoresResponse> getScores(String token) async {
    final response = await _dio.get(ApiConstants.scores,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    return ScoresResponse.fromJson(response.data);
  }

  Future<SendFriendRequestResponse> sendFriendRequest(
      String email, String token) async {
    final response = await _dio.post(ApiConstants.sendFriendRequest,
        data: {"receiverEmail": email},
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return SendFriendRequestResponse.fromJson(response.data);
  }

  Future<FriendRequestsResponse> getFriendRequests(String token) async {
    final response = await _dio.get(ApiConstants.getFriendRequests,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    return FriendRequestsResponse.fromJson(response.data);
  }

  Future<SendFriendRequestResponse> acceptFriendRequest(
      String email, String token) async {
    final response = await _dio.post(ApiConstants.acceptFreindRequest,
        data: {"senderEmail": email},
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return SendFriendRequestResponse.fromJson(response.data);
  }

  Future<SendFriendRequestResponse> rejectFriendRequest(
      String email, String token) async {
    final response = await _dio.post(ApiConstants.rejectRequest,
        data: {"senderEmail": email},
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return SendFriendRequestResponse.fromJson(response.data);
  }

  Future<RecommendationResponse> getRecommendation(String token) async {
    final response = await _dio.get(ApiConstants.getRecommendation,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    return RecommendationResponse.fromJson(response.data);
  }
}
