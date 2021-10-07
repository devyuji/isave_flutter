// pub.dev
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:dio/dio.dart";
import 'package:string_validator/string_validator.dart';

// custom
import 'package:isave/widgets/intro.dart';
import 'package:isave/utils/toast.dart';
import 'package:isave/utils/instagram_parser.dart';
import 'package:isave/widgets/loading.dart';
import 'package:isave/widgets/content.dart';

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
  final TextEditingController _inputController = TextEditingController();
  late FocusNode _input;
  late final PageController pageController;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();

    _input = FocusNode();

    pageController = PageController(
      initialPage: 0,
    );

    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round() + 1;
      });
    });

    _inputController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputController.removeListener(() {});
    _input.dispose();
    pageController.dispose();
    pageController.removeListener(() {});

    super.dispose();
  }

  Future<void> fetchApi(String value) async {
    if (value.isEmpty || !isURL(value)) return;

    try {
      String id = InstagramParser.postUrl(value);
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
        toastMessage("Something went wrong!");
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

      if (show) {
        pageController.animateToPage(0,
            duration: const Duration(milliseconds: 550),
            curve: Curves.bounceInOut);
      }

      setState(() {
        username = data['username'];
        show = true;
      });
    } catch (err) {
      debugPrint('something went wrong! #FETCH POST');
      toastMessage("Something went wrong!");
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
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 10.0),
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
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                prefixIcon: const Icon(Icons.link_rounded, color: Colors.black),
                suffixIcon: _inputController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _inputController.clear();
                        },
                        icon: Icon(
                          Icons.clear_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : IconButton(
                        onPressed: clipboard,
                        iconSize: 22.0,
                        icon: Icon(
                          Icons.content_paste_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                hintText: "paste instagram url here!",
              ),
              autocorrect: false,
              cursorColor: Colors.black,
              onSubmitted: fetchApi,
            ),
          ),
          if (show)
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: SelectableText(
                "@$username",
                style: const TextStyle(fontSize: 17.0),
              ),
            ),
          Expanded(
            child: show
                ? Stack(
                    children: [
                      Content(data: _data, controller: pageController),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 0, 0, 0.8),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          width: 50.0,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            '$currentPage/${_data.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : const Intro(name: 'post'),
          )
        ],
      ),
    );
  }
}
