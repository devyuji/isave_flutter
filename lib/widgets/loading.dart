import 'package:flutter/material.dart';
import 'package:isave/constraint.dart';

class Loading {
  static Future<void> show(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    bool shouldPop = false;

    return showDialog(
      context: context,
      barrierDismissible: shouldPop,
      barrierColor: isDarkMode
          ? Colors.black.withOpacity(0.5)
          : Colors.white.withOpacity(0.2),
      builder: (_) => WillPopScope(
        onWillPop: () async => shouldPop,
        child: Dialog(
          backgroundColor: isDarkMode ? kDarkPrimaryColor : Colors.white,
          insetAnimationCurve: Curves.easeIn,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultPadding * 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding * 2.5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  width: 15.0,
                  height: 15.0,
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                    strokeWidth: 2.0,
                  ),
                ),
                const SizedBox(
                  width: kDefaultPadding * 2,
                ),
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: isDarkMode ? kDarkTextColor : kTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

// AlertDialog(
//           elevation: 1,
//           backgroundColor: isDarkMode ? kDarkPrimaryColor : Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(kDefaultPadding),
//           ),
//           title: Row(
//             children: <Widget>[
//               const SizedBox(
//                 width: 15.0,
//                 height: 15.0,
//                 child: CircularProgressIndicator(
//                   color: Colors.grey,
//                   strokeWidth: 2.0,
//                 ),
//               ),
//               const SizedBox(width: kDefaultPadding * 2),
//               Text(
//                 "Loading...",
//                 style: TextStyle(
//                   color: isDarkMode ? kDarkTextColor : kTextColor,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 18.0,
//                 ),
//               ),
//             ],
//           ),
//         ),