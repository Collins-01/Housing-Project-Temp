import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessages {
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 17,
      timeInSecForIosWeb: 4,
      backgroundColor: Colors.orangeAccent,
      textColor: Colors.white,
    );
  }
}
