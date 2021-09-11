// pub.dev
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:dio/dio.dart";
import 'package:string_validator/string_validator.dart';

// custom
import 'package:isave/widgets/intro.dart';
import 'package:isave/widgets/items.dart';
import 'package:isave/utils/toast.dart';
import 'package:isave/utils/instagramParser.dart';
import 'package:isave/widgets/loading.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  List<Map> _data = [];
  bool show = false;
  String username = "";
  bool _loading = false;
  TextEditingController _inputController = TextEditingController();
  late FocusNode _input;

  @override
  void initState() {
    super.initState();

    _input = FocusNode();

    _inputController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _input.dispose();

    super.dispose();
  }

  Future<void> fetchApi(String value) async {
    if (value.isEmpty || !isURL(value)) return;

    try {
      String id = instagramUrlParser(value);
      const String url = ''; // api url
      final send = {"id": id};

      setState(() {
        _loading = true;
      });

      var res = await Dio().post(
        url,
        data: send,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Connection": "keep-alive",
          },
        ),
      );

      if (res.statusCode != 200) {
        ToastMessage("Something went wrong!");
        setState(() {
          _loading = false;
        });
        return;
      }

      var data = res.data;
      if (_data.isNotEmpty) {
        _data = [];
      }

      if (data['type'] == 'slide') {
        data['links'].forEach((d) {
          if (d['type'] == 'image') {
            _data.add(
                {"image_url": d['image_url'], "download_url": d['image_url']});
          } else {
            _data
                .add({"image_url": d['video_img'], "download_url": d['video']});
          }
        });
      } else if (data['type'] == 'video') {
        _data.add(
            {"image_url": data['video_img'], "download_url": data['video']});
      } else {
        _data.add({
          "image_url": data['image_url'],
          "download_url": data['image_url']
        });
      }

      setState(() {
        username = data['username'];
        show = true;
      });
    } catch (err) {
      print('error = $err');
      ToastMessage("Something went wrong!");
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> clipboard() async {
    FocusScope.of(context).requestFocus(_input);
    Map result =
        await SystemChannels.platform.invokeMethod('Clipboard.getData');

    // ignore: unnecessary_null_comparison
    if (result == null) return;
    _inputController.text = result['text'];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedOpacity(
            opacity: _loading ? 1 : 0,
            duration: const Duration(milliseconds: 650),
            child: Loading(width: screenWidth),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: _inputController,
              keyboardType: TextInputType.url,
              maxLines: 1,
              focusNode: _input,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                prefixIcon:
                    Icon(Icons.link_rounded, color: Colors.black, size: 25.0),
                suffixIcon: _inputController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _inputController.clear();
                        },
                        iconSize: 25.0,
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : IconButton(
                        onPressed: clipboard,
                        iconSize: 22.0,
                        icon: Icon(Icons.paste_rounded,
                            color: Theme.of(context).primaryColor),
                      ),
                hintText: "Paste instagram url here!",
              ),
              autocorrect: false,
              cursorColor: Colors.black,
              onSubmitted: fetchApi,
            ),
          ),
          Expanded(
            child: show
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Items(data: _data),
                  )
                : Intro(name: 'post'),
          ),
        ],
      ),
    );
  }
}
