import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:track_wise_mobile_app/core/provider/permission_noti.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class PermissionFailedScreen extends StatefulWidget {
  const PermissionFailedScreen({super.key});

  @override
  State<PermissionFailedScreen> createState() => _PermissionFailedScreenState();
}

class _PermissionFailedScreenState extends State<PermissionFailedScreen>
    with WidgetsBindingObserver {
  PermissionStatus? stepsPermission;
  bool usagePermission = false;
  bool isLoading = true;
  static const platform = MethodChannel('usage_stats');
  _checkStepsPermission() async {
    stepsPermission = await Permission.activityRecognition.request();
    setState(() {});
    if (!stepsPermission!.isGranted) {
      openAppSettings();
    } else {
      kPermission.value = (usagePermission &&
          stepsPermission != null &&
          stepsPermission!.isGranted);
    }
  }

  _initFunction() async {
    usagePermission = await platform.invokeMethod('checkUsageAccess');
    stepsPermission = await Permission.activityRecognition.request();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initFunction();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      usagePermission = await platform.invokeMethod('checkUsageAccess');
      stepsPermission = await Permission.activityRecognition.status;
      setState(() {});
      kPermission.value = (usagePermission &&
          stepsPermission != null &&
          stepsPermission!.isGranted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 16),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text("Grant Access",
                          style: TextStyle(
                              fontSize: 30.sp,
                              color: ColorsManager.blue,
                              fontWeight: FontWeight.bold)),
                    ),
                    Text(
                      'sorry you have to grant usage and steps access',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Lottie.asset('assets/lotties/permissions_lottie.json'),
                    const SizedBox(
                      height: 20,
                    ),
                    if (!usagePermission) ...[
                      SizedBox(
                        height: 30.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsManager.blue,
                                foregroundColor: Colors.white),
                            onPressed: () async {
                              await platform
                                  .invokeMethod('openUsageAccessSettings');
                            },
                            child: Text(
                              'Grant access For Usage',
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                    if (stepsPermission == null ||
                        !stepsPermission!.isGranted) ...[
                      SizedBox(
                        height: 30.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsManager.blue,
                                foregroundColor: Colors.white),
                            onPressed: _checkStepsPermission,
                            child: Text(
                              'Grant access For Steps',
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.bold),
                            )),
                      ),
                    ]
                  ],
                ),
              ),
      ),
    );
  }
}
