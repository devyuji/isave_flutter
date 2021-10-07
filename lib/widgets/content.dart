import 'package:flutter/material.dart';
import 'package:isave/widgets/item.dart';

class Content extends StatelessWidget {
  final List<Map> data;
  final PageController controller;
  const Content({required this.data, required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      children: data
          .map((d) => Item(
                imageLink: d['image_url'],
                downloadLink: d['download_url'],
              ))
          .toList(),
    );
  }
}
