import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:isave/models.dart';
import 'package:collection/collection.dart';
import 'package:isave/utils/toast.dart';

class DownloaderState with ChangeNotifier {
  int selectedTab = 0;
  List<Data> data = [];
  String username = "";

  void changeSelectedTab(int res) {
    selectedTab = res;

    notifyListeners();
  }

  Uint8List _convertImageToBase(String url) {
    return const Base64Decoder().convert(url);
  }

  void setData(final d, bool isProfile) {
    data.clear();

    if (isProfile) {
      username = d['username'];
      final profileImage = _convertImageToBase(d['image_url']);
      data.add(Data(
        isVideo: false,
        downloadLink: d['profile_image'],
        preview: profileImage,
      ));
    } else {
      username = d['username'];

      if (d['type'] == 'slide') {
        for (var i in d['links']) {
          if (i['type'] == 'image') {
            Uint8List imageSrc = _convertImageToBase(i['image_src']);

            data.add(
              Data(
                isVideo: false,
                downloadLink: i['image_url'],
                preview: imageSrc,
              ),
            );
          } else {
            Uint8List imageSrc = _convertImageToBase(i['image_src']);

            data.add(
              Data(
                isVideo: true,
                downloadLink: i['video'],
                preview: imageSrc,
              ),
            );
          }
        }
      } else if (d['type'] == 'image') {
        Uint8List imageSrc = _convertImageToBase(d['image_src']);

        data.add(
          Data(
            isVideo: false,
            downloadLink: d['image_url'],
            preview: imageSrc,
          ),
        );
      } else {
        Uint8List imageSrc = _convertImageToBase(d['image_src']);
        data.add(
          Data(
            isVideo: true,
            downloadLink: d['video'],
            preview: imageSrc,
          ),
        );
      }
    }

    notifyListeners();
  }

  void changeStatus(String id) {
    final receive = data.firstWhereOrNull((element) => element.taskId == id);

    if (receive == null) return;

    receive.status = DownloadTaskStatus.undefined;

    notifyListeners();
  }

  void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final receive = data.firstWhereOrNull((element) => element.taskId == id);

    if (receive == null) {
      return;
    }

    receive.status = status;
    receive.progress = progress;

    if (status == DownloadTaskStatus.failed) {
      toastMessage("Download Failed!");
    }

    notifyListeners();
  }
}
