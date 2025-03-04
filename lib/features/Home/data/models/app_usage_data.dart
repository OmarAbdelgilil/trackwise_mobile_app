import 'dart:convert';
import 'dart:typed_data';

class AppUsageData {
  String appName;
  Duration usageTime;
  Uint8List appIcon;
  AppUsageData(
      {required this.appName, required this.usageTime, required this.appIcon});

  factory AppUsageData.fromJson(Map<dynamic, dynamic> json) {
    if (json['usageMinutes'].runtimeType == double) {
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
        usageTime: json['usageMinutes'] as Duration,
        appIcon: json['appIcon'] as Uint8List);
  }

  Map<String, dynamic> toJson() =>
      {'appName': appName, 'usageMinutes': usageTime, 'appIcon': base64Encode(appIcon)};
}
