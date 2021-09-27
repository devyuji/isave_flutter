// pub.dev
import 'package:flutter/material.dart';

// custom
import 'package:isave/utils/download.dart';

class Items extends StatelessWidget {
  final List<Map> data;
  final PageController controller;

  const Items({
    Key? key,
    required this.data,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int totalLength = data.length;
    int index = 0;

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      padEnds: false,
      physics: BouncingScrollPhysics(),
      children: data.map((e) {
        index++;
        return Stack(
          children: [
            Image.network(
              e['image_url'],
              fit: BoxFit.contain,
              width: double.infinity,
            ),
            Positioned(
              top: 5,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: IconButton(
                  iconSize: 25.0,
                  onPressed: () {
                    var extension =
                        e['download_url'].split('?')[0].split('.').last;
                    String fileName =
                        "isave-${DateTime.now().minute}.$extension";
                    download(e['download_url'], fileName);
                  },
                  icon: Icon(
                    Icons.download,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10.0,
              right: 10.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.black.withOpacity(0.8),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 15.0,
                ),
                child: Text(
                  '$index/$totalLength',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ],
        );
      }).toList(),
    );
  }
}
