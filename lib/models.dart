import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class Data {
  final Uint8List preview;
  final String downloadLink;
  final bool isVideo;

  String? taskId;
  int? progress;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  Data({
    required this.isVideo,
    required this.downloadLink,
    required this.preview,
  });
}

class ProfileData {
  Uint8List? profileImage;
  String? bio = "";
  String? username = "";
  String? name = "";
  int? followers = 0;
  int? followings = 0;
  int? posts = 0;
  String? downloadLink = "";

  ProfileData({
    this.profileImage,
    this.followers,
    this.followings,
    this.name,
    this.posts,
    this.bio,
    this.username,
    this.downloadLink,
  });
}

class Menu {
  final String name;
  final Widget widget;

  Menu({required this.name, required this.widget});
}

class CompletedDownload {
  final String taskId;
  final File dir;
  final bool isVideo;
  final String fileName;

  CompletedDownload({
    required this.dir,
    required this.taskId,
    required this.isVideo,
    required this.fileName,
  });
}

class Update {
  final bool isUpdateAvailable;
  final String latesVersion;
  final String appVersion;

  Update({
    required this.isUpdateAvailable,
    required this.latesVersion,
    required this.appVersion,
  });
}

class PreviewData {
  ProfileData profile;
  final List<Uint8List> post;

  PreviewData({required this.profile, required this.post});
}
