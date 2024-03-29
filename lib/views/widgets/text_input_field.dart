import 'package:flutter/material.dart';

import '../../constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isObsecure;
  final String labelText;
  final IconData icon;

  const TextInputField({
    Key? key,
    required this.controller,
    this.isObsecure = false,
    required this.icon,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: labelText,
        labelStyle: TextStyle(fontSize: 20),
        prefixIcon: Icon(icon),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: kBorderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: kFocusedBorderColor, width: 2),

        ),
      ),
      obscureText: isObsecure,
    );
  }
}
