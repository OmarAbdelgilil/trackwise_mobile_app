import 'package:flutter/material.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppTile extends StatelessWidget {
  const AppTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(FontAwesomeIcons.instagram, color: Colors.black), 
              ),
              title: const Text(
                'Instagram',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    //number of hours / max number of hours in this day
                    value: 6 / 8,
                    backgroundColor: Colors.grey.shade800,//Color.fromARGB(0, 66, 66, 66), 
                    valueColor:const AlwaysStoppedAnimation<Color>(ColorsManager.blue),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '6hrs',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                ],
              ),
            );
  }
}