import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  final String name;

  const Intro({
    required this.name,
    Key? key,
  }) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: <Widget>[
          Image.asset(
            'assets/images/${widget.name}.png',
            fit: BoxFit.cover,
            height: 300,
          )
        ],
      ),
    );
  }
}
