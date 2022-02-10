import 'package:flutter/material.dart';

void snackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(
      msg,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      ),
    ),
    backgroundColor: Colors.yellow,
  ));
}
