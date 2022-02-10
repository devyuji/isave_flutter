import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

// custom
import 'package:isave/models.dart';
import 'package:isave/utils/toast.dart';

class DownloadFile {
  Data? data;
  String? fileName;

  DownloadFile({
    this.data,
    this.fileName,
  });

  void start() async {
    try {
      String? dir = await _getPath();

      data?.taskId = await FlutterDownloader.enqueue(
        url: data!.downloadLink,
        savedDir: dir!,
        fileName: fileName!,
        showNotification: true,
        saveInPublicStorage: true,
        openFileFromNotification: true,
        requiresStorageNotLow: true,
      );
      toastMessage("Download starting");
    } catch (_) {
      toastMessage("UH-OH Failed to download");
    }
  }

  static Future<bool> askPermission() async {
    final response = await Permission.storage.request();

    if (response.isGranted) {
      return true;
    }

    return false;
  }

  Future<String?> _getPath() async {
    Directory? downloadPath = await getExternalStorageDirectory();
    var f = downloadPath?.path.split('/');
    int length = f!.length;
    String path = "";
    for (var i = 0; i < length; i++) {
      if (f[i] == 'Android') break;

      path = path + f[i] + '/';
    }
    path = path + "Download/";
    try {
      Directory(path).create(recursive: true);
    } catch (_) {}

    return path;
  }

  static void openFile(String id) {
    try {
      FlutterDownloader.open(taskId: id);
    } catch (_) {
      toastMessage("UH-OH Unable to open file");
    }
  }

  static void deleteFile(String id) {
    try {
      FlutterDownloader.remove(taskId: id, shouldDeleteContent: true);
    } catch (err) {
      toastMessage("UH-OH unable to delete file");
    }
  }
}
