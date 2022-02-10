import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isave/custom_route.dart';
import 'package:isave/provider/downloader_state.dart';
import 'package:isave/screens/check_for_update.dart';
import 'package:isave/utils/notification.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// custom
import 'package:isave/constraint.dart';
import 'package:isave/screens/home/screens/preview.dart';
import 'package:isave/screens/home/screens/downloader.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ReceivePort _port = ReceivePort();
  int _bottomNavigationIndex = 0;
  final Connectivity _connectivity = Connectivity();
  bool _isModalOpen = false;

  @override
  void initState() {
    super.initState();

    _prepare();

    _bindConnection();

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    _unbindConnection();

    super.dispose();
  }

  void _prepare() async {
    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      _noConnectionModal();

      _isModalOpen = true;
    }

    _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        _noConnectionModal();

        _isModalOpen = true;
        return;
      }

      if (_isModalOpen) {
        Navigator.of(context).pop();

        _isModalOpen = false;
      }
    });

    LocalNotification.streamController.stream.listen((event) {
      if (event == "update") {
        Navigator.push(context, customRouteAnimation(const CheckForUpdate()));
      }
    });
  }

  Future<void> _noConnectionModal() {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    bool shouldPop = false;

    return showDialog(
      barrierDismissible: shouldPop,
      context: context,
      barrierColor: isDarkMode
          ? Colors.black.withOpacity(0.5)
          : Colors.white.withOpacity(0.5),
      builder: (_) => WillPopScope(
        onWillPop: () async => shouldPop,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: isDarkMode ? kDarkPrimaryColor : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(kDefaultPadding * 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/wifi-off.svg",
                    height: 30.0,
                    width: 30.0,
                  ),
                ),
                const SizedBox(height: kDefaultPadding * 2),
                const Text(
                  "No internet connection!",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                const Text(
                  "Make sure Wi-Fi or mobile data is turned on then try again",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _bindConnection() {
    bool isSuccess =
        IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader');
    if (!isSuccess) {
      _unbindConnection();
      _bindConnection();
      return;
    }

    _port.listen((message) {
      Provider.of<DownloaderState>(context, listen: false)
          .downloadCallback(message[0], message[1], message[2]);
    });
  }

  void _unbindConnection() {
    IsolateNameServer.removePortNameMapping('downloader');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader')!;

    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        children: const <Widget>[Downloader(), Preview()],
        index: _bottomNavigationIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() {
          _bottomNavigationIndex = index;
        }),
        currentIndex: _bottomNavigationIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_downward_rounded),
            label: "Downloader",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_mosaic_rounded),
            label: "Preview",
          ),
        ],
      ),
    );
  }
}
