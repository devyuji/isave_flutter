import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isave/constraint.dart';

class CustomTheme {
  static ThemeData light() {
    return ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.white,
      brightness: Brightness.light,
      fontFamily: "Poppins",
      appBarTheme: AppBarTheme(
        backgroundColor: kBackgroundColor,
        iconTheme: const IconThemeData(
          color: kTextColor,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: kBackgroundColor,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: const TextStyle(
          color: kTextColor,
          fontWeight: FontWeight.w700,
          fontSize: 20.0,
        ),
      ),
      scaffoldBackgroundColor: kBackgroundColor,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        selectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(
          color: kTextColor,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding * 2),
        ),
        color: Colors.white,
        textStyle: const TextStyle(
          color: kTextColor,
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.black,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: "Poppins",
      primarySwatch: Colors.grey,
      primaryColor: kDarkPrimaryColor,
      scaffoldBackgroundColor: kDarkBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: kDarkBackgroundColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: kDarkBackgroundColor,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          color: kDarkTextColor,
          fontWeight: FontWeight.w700,
          fontSize: 25.0,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kDarkPrimaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        selectedItemColor: Colors.white,
      ),
      popupMenuTheme: PopupMenuThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding * 2),
        ),
        color: kDarkPrimaryColor,
        textStyle: const TextStyle(
          color: kDarkTextColor,
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.black,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
      ),
    );
  }
}
