import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
void ToastMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
