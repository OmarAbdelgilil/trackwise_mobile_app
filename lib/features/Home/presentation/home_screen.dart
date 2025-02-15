import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/app_tile.dart';
import 'package:track_wise_mobile_app/features/Home/presentation/widgets/circle_progress_bar.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';
import 'package:track_wise_mobile_app/utils/image_path_manager.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(ImagePathManager.heartBeat,
                              fit: BoxFit.contain,
                              width: 20.w,
                              
                            ),
            SizedBox(width: 7.w,),
            Text(
              StringsManager.homeScreenTitle,
              style: TextStyle(fontSize: 24.sp, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: ColorsManager.backgroundColor,
        actions: [IconButton(icon: const Icon(Icons.notifications_none),onPressed: () {},)],
      ),
      backgroundColor: ColorsManager.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:18.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleProgressBar(),
              Container(alignment: Alignment.centerLeft,padding: EdgeInsets.only(left: 8.h) ,child: const Text(StringsManager.apps,style: TextStyle(color: Colors.white,fontSize: 20),)),
              SizedBox(
                height: 360.h,
                child: ListView(
                  children: const [
                    AppTile()
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}