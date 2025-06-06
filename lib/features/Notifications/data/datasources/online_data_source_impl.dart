import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_wise_mobile_app/core/api/api_execution.dart';
import 'package:track_wise_mobile_app/core/api/api_manager.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/Notifications/data/contracts/online_data_source.dart';
import 'package:track_wise_mobile_app/features/Notifications/data/response/recommendation_response/recommendation_response.dart';

@Injectable(as: OnlineDataSource)
class OnlineDataSourceImpl extends OnlineDataSource {
  final SharedPreferences _prefs;
  final ApiManager _apiManager;
  OnlineDataSourceImpl(this._prefs, this._apiManager);

  @override
  Future<Result<RecommendationResponse>> getRecommendation() {
    return executeApi(
      () async {
        final result =
            await _apiManager.getRecommendation(_prefs.getString("token")!);
        return result;
      },
    );
  }
}
