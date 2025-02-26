import 'dart:async';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';

Future<Result<T>> executeHive<T>(Future<T> Function() hiveCall) async {
  try {
    var result = await hiveCall.call();
    return Success(result);
  } on HiveError catch (ex) {
    return Fail(Exception(ex.message));
  } on IOException {
    return Fail(Exception("Hive IO Error"));
  } on Exception catch (ex) {
    return Fail(ex);
  }
}
