import 'package:flutter/material.dart';
import 'package:track_wise_mobile_app/features/steps/presentation/steps_viewmodel.dart';
import 'package:track_wise_mobile_app/utils/custom_text_field.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

void showStepsDataDialogDialog(
    BuildContext context, StepsViewmodel prov) async {
  final TextEditingController weightController =
      TextEditingController(text: prov.weight.toString());
  final TextEditingController heightController = TextEditingController(
      text: (prov.strideLength / (0.414 * 0.01)).round().toString());
  final TextEditingController dailyTargetController =
      TextEditingController(text: prov.dailyTarget.toString());
  final formKey = GlobalKey<FormState>();
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          "Steps data",
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextField(
                controller: dailyTargetController,
                label: StringsManager.dailyTargetLabel,
                hint: StringsManager.dailyTargetHint,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return StringsManager.textFieldError;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: heightController,
                label: StringsManager.heightLabel,
                hint: StringsManager.heightHint,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return StringsManager.textFieldError;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: weightController,
                label: StringsManager.weightLabel,
                hint: StringsManager.weightHint,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return StringsManager.textFieldError;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.pop(context);
                prov.setStepsData(
                    myWeight: int.parse(weightController.text),
                    myDailyTarget: int.parse(dailyTargetController.text),
                    heightCm: double.parse(heightController.text));
              }
            },
            child: const Text("Ok"),
          ),
        ],
      );
    },
  );
}
