import 'package:flutter/material.dart';
import 'package:track_wise_mobile_app/utils/change_date_mode.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class HomeToggleButton extends StatelessWidget {
  final dynamic prov;
  final String text;
  final ChangeDateMode toggle;
  const HomeToggleButton(
      {super.key,
      required this.prov,
      required this.text,
      required this.toggle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        prov.toggleDateMode(toggle);
      },
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary.withValues(
                    red: 0,
                    green: 0,
                    alpha: 0,
                    blue: 0,
                  )),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            side: BorderSide(
                color: toggle == prov.changeDateMode
                    ? ColorsManager.primaryColor
                    : ColorsManager.lightgrey),
            borderRadius: const BorderRadius.all(Radius.zero),
          ))),
      child: Text(
        text,
        style: TextStyle(
            color: toggle == prov.changeDateMode
                ? ColorsManager.primaryColor
                : ColorsManager.lightgrey),
      ),
    );
  }
}
