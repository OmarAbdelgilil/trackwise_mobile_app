class RecommendedApp {
  String? packageName;
  String? appName;

  RecommendedApp({this.packageName, this.appName});

  factory RecommendedApp.fromJson(Map<String, dynamic> json) {
    return RecommendedApp(
      packageName: json['package_name'] as String?,
      appName: json['app_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'package_name': packageName,
        'app_name': appName,
      };
}
