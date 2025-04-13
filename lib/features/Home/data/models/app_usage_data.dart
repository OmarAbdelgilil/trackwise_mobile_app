import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppUsageData {
  String appName;
  String packageName;
  Duration usageTime;
  Uint8List appIcon;
  AppUsageData(
      {required this.appName,
      required this.usageTime,
      required this.appIcon,
      required this.packageName});
  static const _platform = MethodChannel('usage_stats');
  factory AppUsageData.fromJson(Map<dynamic, dynamic> json) {
    if (json['usageMinutes'].runtimeType == double ||
        json['usageMinutes'].runtimeType == int) {
      json['usageMinutes'] =
          Duration(milliseconds: (json['usageMinutes'] * 60000).toInt());
    } else if (json['usageMinutes'].runtimeType != Duration) {
      json['usageMinutes'] = const Duration(milliseconds: 0);
    }

    try {
      final n =
          json['appIcon'].toString().replaceAll("\n", "").replaceAll("\r", "");
      json['appIcon'] = base64Decode(n);
    } catch (e) {
      json['appIcon'] = Uint8List(0);
    }
    return AppUsageData(
        appName: json['appName'] as String,
        packageName: (json['packageName'] ?? '') as String,
        usageTime: json['usageMinutes'] as Duration,
        appIcon: json['appIcon'] as Uint8List);
  }

  static Future<AppUsageData> _fromJsonResponse(
      Map<dynamic, dynamic> json) async {
    if (json['usageMinutes'].runtimeType == double ||
        json['usageMinutes'].runtimeType == int) {
      json['usageMinutes'] =
          Duration(milliseconds: (json['usageMinutes'] * 60000).toInt());
    } else if (json['usageMinutes'].runtimeType != Duration) {
      json['usageMinutes'] = const Duration(milliseconds: 0);
    }

    try {
      json['appIcon'] = json['packageName'] != null && json['packageName'] != ''
          ? await _platform
              .invokeMethod('getIcon', {"packageName": json['packageName']})
          : '';
      json['appIcon'] = base64Decode(
          json['appIcon'].toString().replaceAll("\n", "").replaceAll("\r", ""));
    } catch (e) {
      json['appIcon'] = Uint8List(0);
    }
    return AppUsageData(
        appName: json['appName'] as String,
        usageTime: json['usageMinutes'] as Duration,
        packageName: json['packageName'],
        appIcon: json['appIcon'] as Uint8List);
  }

  Map<String, dynamic> toJson() => {
        'appName': appName,
        'usageMinutes': usageTime.inMinutes,
        'appIcon': base64Encode(appIcon),
        'packageName': packageName
      };
  Map<String, dynamic> _toJsonRequest() => {
        'appName': appName,
        'usageMinutes': usageTime.inMinutes,
        'packageName': packageName
      };
  static Map<String, List<Map<String, dynamic>>> toRequest(
      Map<DateTime, List<AppUsageData>> usageData) {
    return usageData.map((key, value) {
      return MapEntry(
        DateFormat('d-M-yyyy').format(key),
        value.map((data) => data._toJsonRequest()).toList(),
      );
    });
  }

  static Future<Map<DateTime, List<AppUsageData>>> fromRequest(
      Map<String, dynamic> requestData) async {
    final result = <DateTime, List<AppUsageData>>{};
    for (var entry in requestData.entries) {
      final date = DateFormat('d-M-yyyy').parse(entry.key);
      final appUsageDataList = await Future.wait(List.from(
          entry.value.map((data) => AppUsageData._fromJsonResponse(data))));

      result[date] = appUsageDataList.cast<AppUsageData>();
    }
    return result;
  }
}
