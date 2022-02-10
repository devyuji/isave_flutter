import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

// custom
import 'package:isave/provider/downloader_state.dart';
import 'package:isave/constraint.dart';
import 'package:isave/utils/download.dart';
import 'package:isave/utils/toast.dart';
import 'package:isave/models.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Data data;

  void _download(Data data, bool isVideo) async {
    bool res = await DownloadFile.askPermission();
    if (!res) {
      toastMessage("Grant Permission to download");
      return;
    }
    late String fileName;
    if (isVideo) {
      fileName = "isave-${_generateRandomName()}.mp4";
    } else {
      fileName = "isave-${_generateRandomName()}.jpg";
    }

    DownloadFile(fileName: fileName, data: data).start();
  }

  String _generateRandomName() {
    const String _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(
      Iterable.generate(
        5,
        (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _username = Provider.of<DownloaderState>(context).username;
    final size = MediaQuery.of(context).size;
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding * 2),
        decoration: BoxDecoration(
          color: isDarkMode ? kDarkPrimaryColor : Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    _username,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      color: isDarkMode ? kDarkTextColor : kTextColor,
                    ),
                  ),
                ),
                data.isVideo
                    ? Icon(
                        Icons.smart_display_rounded,
                        color: isDarkMode ? kDarkTextColor : kTextColor,
                      )
                    : Icon(
                        Icons.image_rounded,
                        color: isDarkMode ? kDarkTextColor : kTextColor,
                      )
              ],
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            Hero(
              tag: data.preview,
              child: SizedBox(
                height: size.height * 0.4,
                width: size.width,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  child: Image.memory(
                    data.preview,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Column(
                        children: const <Widget>[
                          Icon(Icons.warning_rounded),
                          SizedBox(height: kDefaultPadding),
                          Text(
                            'Failed to load',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),

            // actions
            Row(
              children: <Widget>[
                TextButton.icon(
                  icon: Icon(
                    Icons.fullscreen_rounded,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/view',
                      arguments: {
                        "isVideo": data.isVideo,
                        "url": data.isVideo ? data.downloadLink : data.preview
                      },
                    );
                  },
                  label: Text(
                    'Preview',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                if (data.status != DownloadTaskStatus.running &&
                    data.status != DownloadTaskStatus.complete)
                  TextButton.icon(
                    icon: Icon(Icons.download,
                        color: isDarkMode ? Colors.white : Colors.black),
                    onPressed: () {
                      _download(data, data.isVideo);
                    },
                    label: Text(
                      'Download',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                if (data.status == DownloadTaskStatus.running &&
                    data.status != DownloadTaskStatus.failed)
                  Expanded(
                    flex: 2,
                    child: LinearProgressIndicator(
                      value: data.progress! / 100,
                    ),
                  ),
                if (data.status == DownloadTaskStatus.complete)
                  TextButton.icon(
                    onPressed: () {
                      DownloadFile.openFile(data.taskId!);
                    },
                    icon: Icon(Icons.open_in_new,
                        color: isDarkMode ? Colors.white : Colors.black),
                    label: Text(
                      'open',
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
