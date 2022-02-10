import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// custom
import 'package:isave/screens/home/widgets/content_card.dart';
import 'package:isave/constraint.dart';
import 'package:isave/custom_route.dart';
import 'package:isave/models.dart';
import 'package:isave/provider/downloader_state.dart';
import 'package:isave/screens/all_downloads.dart';
import 'package:isave/screens/check_for_update.dart';
import 'package:isave/screens/help.dart';
import 'package:isave/screens/home/widgets/input_downloader.dart';
import 'package:isave/screens/home/widgets/intro.dart';

class Downloader extends StatelessWidget {
  const Downloader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Menu> menu = [
      Menu(name: "Downloads", widget: const AllDownloads()),
      Menu(name: "Check for update", widget: const CheckForUpdate()),
      Menu(name: "Help & Feedback", widget: const Help()),
    ];

    final size = MediaQuery.of(context).size;

    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    final _selectedTab = Provider.of<DownloaderState>(context).selectedTab;

    final _data = Provider.of<DownloaderState>(context).data;

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: <Widget>[
        SliverAppBar(
          elevation: 0,
          title: const Text(
            'isave',
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (Widget item) =>
                  Navigator.of(context).push(customRouteAnimation(item)),
              itemBuilder: (_) => menu
                  .map(
                    (e) => PopupMenuItem(
                      value: e.widget,
                      child: Text(
                        e.name,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kDefaultPadding * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Provider.of<DownloaderState>(context, listen: false)
                        .changeSelectedTab(0);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? _selectedTab == 0
                              ? Colors.white
                              : kDarkBackgroundColor
                          : _selectedTab == 0
                              ? Colors.black
                              : kBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(kDefaultPadding * 2),
                        bottomRight: Radius.circular(kDefaultPadding * 2),
                      ),
                    ),
                    width: size.width / 2,
                    child: Text(
                      'Post/Reels',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDarkMode
                            ? _selectedTab == 0
                                ? Colors.black
                                : Colors.white
                            : _selectedTab == 0
                                ? Colors.white
                                : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<DownloaderState>(context, listen: false)
                        .changeSelectedTab(1);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    width: size.width / 2,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? _selectedTab == 1
                              ? Colors.white
                              : kDarkBackgroundColor
                          : _selectedTab == 0
                              ? kBackgroundColor
                              : Colors.black,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(kDefaultPadding * 2),
                        bottomLeft: Radius.circular(kDefaultPadding * 2),
                      ),
                    ),
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDarkMode
                            ? _selectedTab == 1
                                ? Colors.black
                                : Colors.white
                            : _selectedTab == 0
                                ? Colors.black
                                : Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              const Input(),
              const SizedBox(height: kDefaultPadding),
              Visibility(
                visible: _data.isEmpty,
                child: const Intro(text: "post"),
              )
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ContentCard(data: _data[index]),
            childCount: _data.length,
          ),
        ),
      ],
    );
  }
}
