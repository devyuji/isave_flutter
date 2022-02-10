import 'package:isave/provider/update_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// custom
import 'package:isave/constraint.dart';
import 'package:isave/widgets/back.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckForUpdate extends StatelessWidget {
  const CheckForUpdate({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final _update = Provider.of<UpdateState>(context).update;
    final _loading = Provider.of<UpdateState>(context).loading;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: back(context, isDarkMode ? Colors.white : Colors.black),
        title: const Text(
          'Check For Update',
        ),
      ),
      body: _loading
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: kDefaultPadding * 2),
                  Text(
                    'Checking for update',
                    style: TextStyle(
                      color: isDarkMode ? kDarkTextColor : kTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh:
                  Provider.of<UpdateState>(context, listen: false).checkUpdate,
              color: isDarkMode ? Colors.white : Colors.black,
              child: ListView(
                padding: const EdgeInsets.all(kDefaultPadding * 2),
                children: <Widget>[
                  Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          _update.isUpdateAvailable
                              ? 'Update Available'
                              : "No Update Available",
                          style: TextStyle(
                            color: isDarkMode ? kDarkTextColor : kTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 25.0,
                          ),
                        ),
                        const SizedBox(height: kDefaultPadding),
                        Text(
                          'latest version : v${_update.latesVersion}',
                          style: TextStyle(
                            color: isDarkMode ? kDarkTextColor : kTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          'current version : v${_update.appVersion}',
                          style: TextStyle(
                            color: isDarkMode ? kDarkTextColor : kTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: kDefaultPadding),
                        if (_update.isUpdateAvailable)
                          TextButton.icon(
                            onPressed: () {
                              _launchUrl(
                                  "https://github.com/devyuji/isave_flutter/releases");
                            },
                            icon: Icon(
                              Icons.downloading_rounded,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                            label: Text(
                              'Download',
                              style: TextStyle(
                                color: isDarkMode ? Colors.black : Colors.white,
                              ),
                            ),
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(0.0),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  isDarkMode ? Colors.white : Colors.black),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
