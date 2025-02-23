import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:track_wise_mobile_app/core/provider/permission_noti.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class PermissionFailedScreen extends StatefulWidget {
  const PermissionFailedScreen({super.key});

  @override
  State<PermissionFailedScreen> createState() => _PermissionFailedScreenState();
}

class _PermissionFailedScreenState extends State<PermissionFailedScreen>
    with WidgetsBindingObserver {
  static const platform = MethodChannel('usage_stats');
  @override
  void initState() {
    super.initState();
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
      kPermission.value = await platform.invokeMethod('checkUsageAccess');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 16),
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
              'sorry you have to grant usage access',
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30.h,
            ),
            Lottie.asset('assets/lotties/permissions_lottie.json'),
            const SizedBox(
              height: 20,
            ),
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
                    await platform.invokeMethod('openUsageAccessSettings');
                    //
                    //print(kPermission.value);
                  },
                  child: Text(
                    'Grant access',
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
