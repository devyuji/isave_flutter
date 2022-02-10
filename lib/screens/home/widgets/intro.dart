import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isave/constraint.dart';

class Intro extends StatelessWidget {
  const Intro({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return SizedBox(
      height: size.height * 0.5,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: SvgPicture.asset(
            "assets/icons/intro_$text.svg",
            height: size.width * 0.6,
            color: isDarkMode ? kDarkTextColor : kTextColor,
          ),
        ),
      ),
    );
  }
}
