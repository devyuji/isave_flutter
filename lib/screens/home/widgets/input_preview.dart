import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:isave/constraint.dart';
import 'package:isave/provider/preview_state.dart';
import 'package:isave/utils/snack_bar.dart';
import 'package:isave/widgets/loading.dart';
import 'package:provider/provider.dart';

class InputPreview extends StatefulWidget {
  const InputPreview({
    Key? key,
    required bool isTextFieldOpen,
  })  : _isTextFieldOpen = isTextFieldOpen,
        super(key: key);

  final bool _isTextFieldOpen;

  @override
  State<InputPreview> createState() => _InputPreviewState();
}

class _InputPreviewState extends State<InputPreview> {
  late TextEditingController _textController;
  late FocusNode _inputNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _inputNode = FocusNode();

    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _inputNode.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    String value = _textController.text.trim();
    _inputNode.unfocus();

    if (value.isEmpty) {
      snackBar(context, "Enter username");
      return;
    }

    Loading.show(context);

    try {
      final response = await Dio().post(
        "",
        data: {"username": value},
        options: Options(
          contentType: "application/json",
          responseType: ResponseType.json,
        ),
      );

      Provider.of<PreviewState>(context, listen: false).setData(response.data);
    } catch (err) {
      snackBar(context, "UH-OH Something went wrong.");
    }

    Loading.hide(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return AnimatedCrossFade(
      firstChild: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding * 2,
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: isDarkMode
                          ? kDarkPrimaryColor.withOpacity(0.1)
                          : kPrimaryColor.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 15.0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _inputNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(kDefaultPadding),
                    ),
                    hintText: "Enter username...",
                    hintStyle: TextStyle(
                      color: isDarkMode ? kDarkTextColor : Colors.grey,
                    ),
                    fillColor: isDarkMode ? kDarkPrimaryColor : Colors.white,
                    filled: true,
                    prefixIcon: Icon(
                      Icons.person,
                      color: isDarkMode ? kDarkTextColor : kTextColor,
                    ),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? kDarkTextColor : kTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: kDefaultPadding,
            ),
            SizedBox(
              width: 60.0,
              height: 60.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(100.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: isDarkMode
                          ? kDarkPrimaryColor.withOpacity(0.1)
                          : kPrimaryColor.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 15.0,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _onSubmit,
                  icon: Icon(
                    Icons.search_rounded,
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      secondChild: const SizedBox(),
      crossFadeState: widget._isTextFieldOpen
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 550),
      firstCurve: Curves.easeInOutSine,
      sizeCurve: Curves.decelerate,
    );
  }
}
