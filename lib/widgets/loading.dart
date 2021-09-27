import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final double width;

  const Loading({Key? key, required this.width}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _animation;
  double xOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _animation = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
      lowerBound: 1.0,
      upperBound: widget.width - 60,
    )..repeat(reverse: true);

    // print(widget.width);

    _animation.addListener(() {
      setState(() {
        xOffset = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _animation.dispose();
    _animation.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: Transform.translate(
        offset: Offset(xOffset, 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20.0),
          ),
          width: 80.0,
          height: 5.0,
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return child as Widget;
      },
    );
  }
}
