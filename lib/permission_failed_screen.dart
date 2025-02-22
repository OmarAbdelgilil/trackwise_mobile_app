import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:track_wise_mobile_app/core/provider/permission_noti.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class PermissionFailedScreen extends StatefulWidget {
  const PermissionFailedScreen({super.key});

  @override
  State<PermissionFailedScreen> createState() => _PermissionFailedScreenState();
}

class _PermissionFailedScreenState extends State<PermissionFailedScreen> with WidgetsBindingObserver{
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
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    if (state == AppLifecycleState.resumed) {
      kPermission.value = await platform.invokeMethod('checkUsageAccess');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'sorry you have to grant usage access',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: () async{
                await platform.invokeMethod('openUsageAccessSettings');
                //
                //print(kPermission.value);
              }, child: const Text('Grant access'))
            ],
          ),
        ),
      ),
    );
  }
}
