import 'package:flutter/material.dart';

class View extends StatefulWidget {
  const View({Key? key}) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  Map<dynamic, dynamic> args = {};

  @override
  void dispose() {
    args = {};

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map;

    return Hero(
      tag: args['image_url'],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            InteractiveViewer(
              scaleEnabled: true,
              panEnabled: true,
              child: Center(
                child: Image.network(args['image_url']),
              ),
            ),
            Positioned(
              top: 50,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.black,
                ),
                child: IconButton(
                  iconSize: 20.0,
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
