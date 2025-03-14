import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
// import 'package:track_wise_mobile_app/features/Auth/presentation/login/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/core/local/duration_adapter.dart';
import 'package:track_wise_mobile_app/core/provider/permission_noti.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/home_screen.dart';
import 'package:track_wise_mobile_app/loading_screen.dart';
import 'package:track_wise_mobile_app/permission_failed_screen.dart';
import 'package:path_provider/path_provider.dart';

final providerContainer = ProviderContainer();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(DurationAdapter());
  configureDependencies();

  runApp(const ProviderScope(child: MyApp()));
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = MethodChannel('usage_stats');
  @override
  void initState() {
    super.initState();
    platform.invokeMethod('checkUsageAccess').then((result) {
      setState(() {
        kPermission.value = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 890),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'TrackWise',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: GoogleFonts.roboto().fontFamily,
        ),
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
