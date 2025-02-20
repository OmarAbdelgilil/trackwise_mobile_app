import 'dart:convert';
import 'dart:typed_data';

class AppUsageData {
	String appName;
	Duration usageTime;
  Uint8List appIcon;
	AppUsageData({required this.appName,required this.usageTime,required this.appIcon});

	factory AppUsageData.fromJson(Map<dynamic, dynamic> json)
  {
    if(json['usageMinutes'].runtimeType == double)
    {
      json['usageMinutes'] = Duration(milliseconds: (json['usageMinutes'] * 60000).toInt());
    }else if(json['usageMinutes'].runtimeType != Duration)
    {
      json['usageMinutes'] = const Duration(milliseconds: 0);
    }if(json['appIcon'].runtimeType == String)
    {
      try {
    json['appIcon'] = base64Decode(json['appIcon'] as String);
    } catch (e) {
      print('failed to load icon');
      json['appIcon'] = Uint8List(0);
    }
    }else if(json['appIcon'].runtimeType != Uint8List)
    {
      json['appIcon'] = Uint8List(0);
    }
    return AppUsageData(
				appName: json['appName'] as String,
				usageTime: json['usageMinutes'] as Duration,
        appIcon: json['appIcon'] as Uint8List
			);
  }

	Map<String, dynamic> toJson() => {
				'appName': appName,
				'usageMinutes': usageTime,
        'appIcon' : appIcon
			};
}
