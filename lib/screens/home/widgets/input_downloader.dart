import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isave/provider/downloader_state.dart';
import 'package:provider/provider.dart';

// custom
import 'package:isave/utils/instagram_parser.dart';
import 'package:isave/utils/snack_bar.dart';
import 'package:isave/constraint.dart';
import 'package:isave/widgets/loading.dart';

class Input extends StatefulWidget {
  const Input({
    Key? key,
  }) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input>
    with AutomaticKeepAliveClientMixin<Input> {
  late FocusNode inputNode;

  late TextEditingController _textController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    inputNode = FocusNode();
    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    inputNode.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    inputNode.unfocus();
    String value = _textController.text.trim();

    if (value.isEmpty) {
      snackBar(context, "Input field is empty.");
      return;
    }

    Loading.show(context);

    final selectedTab =
        Provider.of<DownloaderState>(context, listen: false).selectedTab;
    try {
      if (selectedTab == 0) {
        String id = instagramUrlParser(value);

        var response = await Dio().post(
          "",
          data: {"id": id},
          options: Options(
            contentType: "application/json",
            responseType: ResponseType.json,
          ),
        );
        Provider.of<DownloaderState>(context, listen: false)
            .setData(response.data, false);
      } else {
        final response = await Dio().post(
          "",
          data: {"username": value},
          options: Options(
            contentType: "application/json",
            responseType: ResponseType.json,
          ),
        );

        Provider.of<DownloaderState>(context, listen: false)
            .setData(response.data, true);
      }
    } catch (err) {
      snackBar(context, "UH-OH Something went wrong.");
    }

    Loading.hide(context);
  }

  void _clear() => _textController.text = "";

  void _copyToClipboard() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);

    if (cdata == null) return;

    _textController.text = cdata.text!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    final _selectedTab = Provider.of<DownloaderState>(context).selectedTab;

    return Padding(
      padding: const EdgeInsets.only(
        top: kDefaultPadding * 2,
        left: kDefaultPadding,
        right: kDefaultPadding,
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: isDarkMode
                        ? kDarkBackgroundColor.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 15.0,
                  )
                ],
              ),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(kDefaultPadding),
                  ),
                  fillColor: isDarkMode ? kDarkPrimaryColor : Colors.white,
                  filled: true,
                  hintText: _selectedTab == 0
                      ? "Paste url here..."
                      : "Enter username",
                  hintStyle:
                      TextStyle(color: isDarkMode ? Colors.white : Colors.grey),
                  prefixIcon: Transform.rotate(
                    angle: 90,
                    child: Icon(
                      Icons.link_rounded,
                      color: isDarkMode ? Colors.white : kTextColor,
                    ),
                  ),
                  suffixIcon: _textController.text.isEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.content_paste_rounded,
                            color: isDarkMode ? Colors.white : kTextColor,
                          ),
                          onPressed: _copyToClipboard,
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: isDarkMode ? Colors.white : kTextColor,
                          ),
                          onPressed: _clear,
                        ),
                ),
                focusNode: inputNode,
                keyboardType: TextInputType.url,
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),
          ),
          const SizedBox(
            width: kDefaultPadding,
          ),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 15.0,
                )
              ],
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(kDefaultPadding * 0.5),
            height: 60.0,
            width: 60.0,
            child: IconButton(
              onPressed: _onSubmit,
              icon: Icon(
                Icons.arrow_downward_rounded,
                color: isDarkMode ? Colors.black : Colors.white,
                size: 25.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
