import 'package:track_wise_mobile_app/core/api/api_error_handler.dart';

String extractErrorMessage(Exception? e) {
  String error = "unknown error occured!";
  if (e is DioHttpException) {
    return e.exception!.response!.data['message'];
  }
  return error;
}
