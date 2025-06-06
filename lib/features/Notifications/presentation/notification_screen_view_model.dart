import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/features/Notifications/data/contracts/online_data_source.dart';
import 'package:track_wise_mobile_app/features/Notifications/data/response/recommendation_response/recommendation_response.dart';
import 'package:track_wise_mobile_app/features/Notifications/data/response/recommendation_response/recommended_app.dart';

@injectable
class NotificationScreenViewModel extends StateNotifier<NotificationsState> {
  final OnlineDataSource _onlineDataSource;

  NotificationScreenViewModel(this._onlineDataSource) : super(InitialState());
  void getRecommendation() async {
    state = LoadingState();
    final result = await _onlineDataSource.getRecommendation();
    switch (result) {
      case Success<RecommendationResponse>():
        state = SuccessState(result.data!.recommendedApp!);
        return;
      case Fail<RecommendationResponse>():
        state = ErrorState(result.exception!);
        return;
    }
  }

  void resetState() {
    state = InitialState();
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationScreenViewModel, NotificationsState>(
        (ref) => getIt<NotificationScreenViewModel>()..getRecommendation());

sealed class NotificationsState {}

class InitialState extends NotificationsState {}

class LoadingState extends NotificationsState {}

class SuccessState extends NotificationsState {
  final RecommendedApp app;
  SuccessState(this.app);
}

class ErrorState extends NotificationsState {
  final Exception error;
  ErrorState(this.error);
}
