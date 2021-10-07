// pub.dev
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

// custom
import 'package:isave/utils/toast.dart';

Future<void> download(String url, String fileName) async {
  bool permissionStatus = await permission();
  String directory = '';

  if (permissionStatus) {
    try {
      Directory? path = await getExternalStorageDirectory();
      List<String> directoryNames = path!.path.split('/');
      for (var i = 0; i < directoryNames.length; i++) {
        if (directoryNames[i] == 'Android') break;

        directory = directory + directoryNames[i] + '/';
      }

      String downloadPath = join(directory, 'isave', fileName);

      await Dio().download(url, downloadPath);
      toastMessage("Download Completed");
    } catch (err) {
      debugPrint('Something Went Wrong! #download');
      toastMessage("Something went wrong!");
    }
  } else {
    toastMessage("Required permission in order to download");
  }
}

Future<bool> permission() async {
  final status = await Permission.storage.request();
  if (status.isDenied) return false;

  return true;
}
