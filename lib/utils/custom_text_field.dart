import 'package:flutter/material.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';
import 'package:track_wise_mobile_app/utils/strings_manager.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final Function(String)? onChange;
  final TextEditingController controller;
  final bool obscureText; // Controls initial text visibility
  final bool? readOnly; // Controls initial text visibility
  final String label;
  final String? Function(String?)? validator;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.hint,
    this.onChange,
    this.obscureText = false, // Default is false (text visible)
    this.validator,
    required this.label,
    required this.controller,
    this.errorText,
    this.readOnly,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText; // Controls the text visibility dynamically
  Color labelColor = ColorsManager.primaryColor;

  @override
  void initState() {
    super.initState();
    // Initialize _obscureText with the value of widget.obscureText
    _obscureText = widget.obscureText;
  }

  String? _validate(String? value) {
    final error = widget.validator != null
        ? widget.validator!(value)
        : (value!.isEmpty ? 'This field is required' : null);
    if (error != null && error.isNotEmpty) {
      setState(() {
        labelColor = Colors.red;
      });
    } else {
      setState(() {
        labelColor = ColorsManager.primaryColor;
      });
    }
    return error;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.label == StringsManager.emailLabel? TextInputType.emailAddress : (widget.label == StringsManager.passwordLabel || widget.label == StringsManager.confirmPasswordLabel) ? TextInputType.visiblePassword : widget.label == StringsManager.phoneNumberLabel? TextInputType.phone :(widget.label == StringsManager.heightLabel || widget.label == StringsManager.weightLabel || widget.label == StringsManager.dailyTargetLabel)? TextInputType.number : null,
      obscureText: _obscureText, // Use _obscureText to toggle visibility
      validator: _validate,
      readOnly: widget.readOnly ?? false,
      onChanged: widget.onChange,
      controller: widget.controller,
      cursorColor: Colors.white,
      obscuringCharacter: '*',
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        errorText: widget.errorText,
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.primaryColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.primaryColor),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(
          widget.label,
          style: TextStyle(color: labelColor),
        ),
        hintText: widget.hint,
        hintStyle: const TextStyle(color: ColorsManager.darkGrey),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: ColorsManager.darkGrey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText; // Toggle text visibility
                  });
                },
              )
            : null, // No icon if obscureText is false
      ),
    );
  }
}
