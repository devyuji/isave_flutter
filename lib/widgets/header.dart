// pub.dev
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

// custom
import 'package:isave/utils/toast.dart';
import 'package:isave/widgets/github_logo_icons.dart';

AppBar header(BuildContext context) {
  void _launchMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => Container(
        color: Colors.white,
        height: 300,
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.android,
                color: Colors.black,
              ),
              title: Text(
                'Know the developer',
                style: Theme.of(context).textTheme.headline2,
              ),
              onTap: () {
                _launchUrl("https://instagram.com/devyuji");
              },
            ),
            ListTile(
              leading: const Icon(
                GithubLogo.github_circled,
                color: Colors.black,
              ),
              title: Text(
                'Visit the project',
                style: Theme.of(context).textTheme.headline2,
              ),
              onTap: () {
                _launchUrl("https://github.com/devyuji/isave_flutter");
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.share,
                color: Colors.black,
              ),
              title: Text(
                'Share',
                style: Theme.of(context).textTheme.headline2,
              ),
              onTap: () {
                Share.share(
                    'Instagram Downloader : https://github.com/devyuji/isave_flutter');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info_rounded,
                color: Colors.black,
              ),
              title: Text(
                'Version 1.0.3',
                style: Theme.of(context).textTheme.headline2,
              ),
              subtitle: const Text('Check for update'),
              onTap: () {
                _launchUrl("https://github.com/devyuji/isave_flutter/releases");
              },
            )
          ],
        ),
      ),
    );
  }

  return AppBar(
    backgroundColor: Colors.white,
    shape: Border(
      bottom: BorderSide(
        color: Colors.grey.shade200,
        width: 1.0,
      ),
    ),
    elevation: 0,
    title: Text(
      "isave",
      style: Theme.of(context).textTheme.headline1,
    ),
    actions: [
      IconButton(
        onPressed: _launchMenu,
        icon: const Icon(
          Icons.menu_rounded,
          color: Colors.black,
          size: 30.0,
        ),
      )
    ],
  );
}

void _launchUrl(String _url) async {
  await canLaunch(_url) ? await launch(_url) : toastMessage('Could not open!');
}
