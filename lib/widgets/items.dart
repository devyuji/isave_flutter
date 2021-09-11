// pub.dev
import 'package:flutter/material.dart';

// custom
import 'package:isave/utils/download.dart';

class Items extends StatelessWidget {
  final List<Map> data;

  const Items({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      cacheExtent: 100.0,
      itemBuilder: (BuildContext context, int index) => Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              data[index]['image_url'],
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: Colors.black,
              ),
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                iconSize: 25.0,
                icon: Icon(Icons.download, color: Colors.white),
                onPressed: () {
                  var extension =
                      data[index]['download_url'].split('?')[0].split('.').last;
                  String fileName = "isave-${DateTime.now()}.$extension";
                  download(data[index]['download_url'], fileName);
                },
              ),
            ),
          ),
        ],
      ),
      separatorBuilder: (_, __) => Divider(
        height: 20.0,
        color: Colors.black54,
      ),
      itemCount: data.length,
    );
  }
}

// class _ItemsState extends State<Items> {}
