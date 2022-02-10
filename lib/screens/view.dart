import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:isave/widgets/back.dart';
import 'package:isave/widgets/video.dart';

class View extends StatelessWidget {
  const View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
        ),
        leading: back(context, Colors.white),
      ),
      body: Hero(
        tag: arg['url'],
        child: InteractiveViewer(
          child: Center(
            child: arg['isVideo']
                ? Video(url: arg['url'])
                : Image.memory(
                    arg['url'],
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
