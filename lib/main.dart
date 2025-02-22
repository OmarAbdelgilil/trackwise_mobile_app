import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
// import 'package:track_wise_mobile_app/features/Auth/presentation/login/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/home_screen.dart';

//import 'package:shared_preferences_android/shared_preferences_android.dart';
Future<void> main() async {
  configureDependencies();
  //final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(const ProviderScope(child: MyApp()));
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        home: const HomeScreen(),
      ),
    );
  }
}
