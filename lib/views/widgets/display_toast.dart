import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DisplayToast {
  void toast(String content) {
    Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      // Duration for which the toast should be visible
      gravity: ToastGravity.BOTTOM,
      // Position of the toast message on the screen
      backgroundColor: Colors.black54,
      // Background color of the toast
      textColor: Colors.white,
      // Text color of the toast message
      fontSize: 16.0, // Font size for the toast message
    );
  }
}