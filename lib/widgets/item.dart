import 'package:flutter/material.dart';
import 'package:isave/utils/download.dart';

class Item extends StatelessWidget {
  final String imageLink;
  final String downloadLink;

  const Item({required this.imageLink, required this.downloadLink, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Image.network(
            imageLink,
            width: double.infinity,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: IconButton(
                onPressed: () {
                  String extension = downloadLink
                      .split('/')
                      .last
                      .split('?')[0]
                      .split('.')
                      .last;
                  int num = DateTime.now().microsecond;
                  String fileName = "isave-$num.$extension";
                  download(downloadLink, fileName);
                },
                icon: const Icon(
                  Icons.file_download_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
