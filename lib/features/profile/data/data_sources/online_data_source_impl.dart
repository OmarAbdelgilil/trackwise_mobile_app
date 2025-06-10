import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_wise_mobile_app/core/api/api_execution.dart';
import 'package:track_wise_mobile_app/core/api/api_manager.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/profile/data/contracts/online_data_source.dart';
import 'package:track_wise_mobile_app/features/profile/data/models/response/user_tags/user_tags.dart';

@Injectable(as: OnlineDataSource)
class OnlineDataSourcesImpl extends OnlineDataSource {
  final ApiManager _apiManager;
  final SharedPreferences _prefs;
  OnlineDataSourcesImpl(this._apiManager, this._prefs);

  @override
  Future<Result<UserTags>> getuserTags() {
    return executeApi(
      () async {
        final result =
            await _apiManager.getUserTags(_prefs.getString("token")!);

        return result;
      },
    );
  }
}
