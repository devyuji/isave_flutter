import 'package:flutter/material.dart';

Widget back(BuildContext context, Color color) {
  return IconButton(
    onPressed: () => Navigator.pop(context),
    icon: Icon(
      Icons.chevron_left_outlined,
      color: color,
      size: 35.0,
    ),
  );
}
