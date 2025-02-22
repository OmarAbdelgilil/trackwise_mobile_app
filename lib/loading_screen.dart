import 'package:flutter/material.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: ColorsManager.backgroundColor, body: Center(child: CircularProgressIndicator(),),);
  }
}