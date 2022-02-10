import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

// custom
import 'package:isave/constraint.dart';
import 'package:isave/models.dart';
import 'package:isave/provider/downloader_state.dart';
import 'package:isave/screens/home/widgets/intro.dart';
import 'package:isave/utils/download.dart';
import 'package:isave/widgets/back.dart';
import 'package:isave/widgets/video.dart';
import 'package:provider/provider.dart';

class AllDownloads extends StatefulWidget {
  const AllDownloads({Key? key}) : super(key: key);

  @override
  State<AllDownloads> createState() => _AllDownloadsState();
}

class _AllDownloadsState extends State<AllDownloads> {
  late List<CompletedDownload> _data;
  bool _loading = true;
  String _currentDelete = "";

  @override
  void initState() {
    super.initState();

    _prepare();
  }

  Future<void> _prepare() async {
    final list = await FlutterDownloader.loadTasks();
    final List<CompletedDownload> l = [];

    for (var i in list!) {
      if (i.status == DownloadTaskStatus.complete) {
        bool isVideo = false;
        if (i.filename?.split('.')[1] == "mp4") {
          isVideo = true;
        }

        l.add(
          CompletedDownload(
            dir: File('${i.savedDir}${i.filename}'),
            taskId: i.taskId,
            isVideo: isVideo,
            fileName: i.filename!,
          ),
        );
      }
    }

    setState(() {
      _loading = false;
      _data = l.reversed.toList();
    });
  }

  void _delete() {
    DownloadFile.deleteFile(_currentDelete);
    Provider.of<DownloaderState>(context, listen: false)
        .changeStatus(_currentDelete);
    setState(() {
      _data.removeWhere((element) => element.taskId == _currentDelete);
    });
    Navigator.of(context).pop();
  }

  Future<void> _popupDelete() async {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? kDarkPrimaryColor : Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
          ),
          title: Text(
            'Are you sure?',
            style: TextStyle(color: isDarkMode ? kDarkTextColor : kTextColor),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Downloaded file will also be deleted.',
                  style: TextStyle(
                    color: isDarkMode ? kDarkTextColor : kTextColor,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey.shade200),
              ),
            ),
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _delete,
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Downloads",
        ),
        leading: back(context, isDarkMode ? Colors.white : Colors.black),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _data.isEmpty
              ? const Center(
                  child: Intro(
                    text: "download",
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _prepare,
                  color: isDarkMode ? Colors.white : Colors.black,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: kDefaultPadding),
                    child: ListView.separated(
                      cacheExtent: 200.0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      itemBuilder: (_, index) => Container(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kDefaultPadding),
                          color: isDarkMode ? kDarkPrimaryColor : Colors.white,
                        ),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(kDefaultPadding),
                              child: SizedBox(
                                width: size.width * 0.3,
                                child: _data[index].isVideo
                                    ? Video(
                                        key: ValueKey(_data[index].taskId),
                                        file: _data[index].dir,
                                      )
                                    : Image.file(
                                        _data[index].dir,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Center(
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
                            const SizedBox(width: kDefaultPadding * 2),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    _data[index].fileName,
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? kDarkTextColor
                                          : kTextColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "type: ${_data[index].isVideo ? "video" : "image"}",
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? kDarkTextColor
                                          : kTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      TextButton.icon(
                                        onPressed: () {
                                          DownloadFile.openFile(
                                              _data[index].taskId);
                                        },
                                        icon: Icon(
                                          Icons.open_in_new_rounded,
                                          color: isDarkMode
                                              ? kDarkTextColor
                                              : kTextColor,
                                        ),
                                        label: Text(
                                          "open",
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? kDarkTextColor
                                                : kTextColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            _currentDelete =
                                                _data[index].taskId;
                                          });
                                          _popupDelete();
                                        },
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red.shade400,
                                        ),
                                        label: Text(
                                          'delete',
                                          style: TextStyle(
                                            color: Colors.red.shade400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      separatorBuilder: (_, __) => const SizedBox(
                        height: kDefaultPadding,
                      ),
                      itemCount: _data.length,
                    ),
                  ),
                ),
    );
  }
}
