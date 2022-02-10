import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isave/constraint.dart';
import 'package:isave/widgets/back.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  void _share() {
    Share.share(
      'Download all media of instagram - https://github.com/devyuji/isave_flutter/releases',
      subject: 'isave - Instagram Downloader',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: back(context, isDarkMode ? Colors.white : Colors.black),
        title: const Text('Help & Feedback'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(kDefaultPadding),
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.download_rounded),
                  title: Text(
                    'Download location',
                    style: TextStyle(
                      color: isDarkMode ? kDarkTextColor : kTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text('/storage/emulated/0/Download'),
                ),
                ListTile(
                  onTap: () {
                    _launchUrl("https://www.instagram.com/devyuji/");
                  },
                  title: Text(
                    'Contact Developer',
                    style: TextStyle(
                      color: isDarkMode ? kDarkTextColor : kTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: const Icon(Icons.person_rounded),
                  subtitle: const Text('Yuji'),
                ),
                ListTile(
                  onTap: () {
                    _launchUrl("https://github.com/devyuji/isave_flutter");
                  },
                  title: Text(
                    "Github",
                    style: TextStyle(
                      color: isDarkMode ? kDarkTextColor : kTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: SvgPicture.asset(
                    "assets/icons/github.svg",
                    color: isDarkMode ? kDarkTextColor : Colors.grey,
                  ),
                ),
                ListTile(
                  onTap: () {
                    _launchUrl(
                        "https://github.com/devyuji/isave_flutter/issues");
                  },
                  title: Text(
                    "Have an issue?",
                    style: TextStyle(
                      color: isDarkMode ? kDarkTextColor : kTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: const Icon(Icons.bug_report_rounded),
                ),
                ListTile(
                  onTap: _share,
                  title: Text(
                    "Share this app",
                    style: TextStyle(
                      color: isDarkMode ? kDarkTextColor : kTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: const Icon(Icons.share_rounded),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Text(
              'App v2.0.0',
              style: TextStyle(
                color: isDarkMode ? kDarkTextColor : kTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
