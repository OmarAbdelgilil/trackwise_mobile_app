import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
// import 'package:track_wise_mobile_app/features/Auth/presentation/login/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/core/local/duration_adapter.dart';
import 'package:track_wise_mobile_app/core/provider/permission_noti.dart';
import 'package:track_wise_mobile_app/core/provider/theme_provider.dart';
import 'package:track_wise_mobile_app/core/themes/theme.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/home_screen.dart';
import 'package:track_wise_mobile_app/firebase_options.dart';
import 'package:track_wise_mobile_app/loading_screen.dart';
import 'package:track_wise_mobile_app/permission_failed_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';

final providerContainer = ProviderContainer();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(DurationAdapter());
  configureDependencies();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: MyApp()));
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  static const platform = MethodChannel('usage_stats');
  Future<bool> _checkPermission() async {
    final usage = await platform.invokeMethod('checkUsageAccess');
    final steps = await Permission.activityRecognition.request();
    return usage && steps.isGranted;
  }

  @override
  void initState() {
    super.initState();
    _checkPermission().then((isGranted) {
      setState(() {
        kPermission.value = isGranted;
      });
    }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        kPermission.value = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    return ScreenUtilInit(
      designSize: const Size(411, 890),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'TrackWise',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: ValueListenableBuilder<bool?>(
            valueListenable: kPermission,
            builder: (context, value, child) {
              return value == null
                  ? const LoadingScreen()
                  : value == false
                      ? const PermissionFailedScreen()
                      : const HomeScreen();
            }),
      ),
    );
  }
}
