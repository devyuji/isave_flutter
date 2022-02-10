import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

// custom
import 'package:isave/models.dart';
import 'package:isave/utils/notification.dart';
import 'package:isave/utils/toast.dart';

class UpdateState with ChangeNotifier {
  Update update = Update(
    appVersion: "",
    isUpdateAvailable: true,
    latesVersion: "",
  );
  bool loading = true;

  Future<void> checkUpdate() async {
    loading = true;
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appVersion = packageInfo.version;
      final response = await Dio().post(
        "",
        data: {"app_version": appVersion},
        options: Options(
          contentType: "application/json",
          responseType: ResponseType.json,
        ),
      );

      update = Update(
        isUpdateAvailable: response.data['update'],
        latesVersion: response.data['new_version'],
        appVersion: appVersion,
      );

      if (update.isUpdateAvailable) {
        LocalNotification().show(
          "Update Available",
          "New Version of the app is available tap to download.",
          "update",
        );
      }
    } catch (err) {
      toastMessage("failed to check update");
    }
    loading = false;

    notifyListeners();
  }
}
