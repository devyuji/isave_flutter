// pub.dev
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_actions/quick_actions.dart';

// custom
import 'package:isave/utils/theme.dart';
import 'package:isave/widgets/header.dart';
import 'package:isave/screens/post.dart';
import 'package:isave/screens/profile.dart';
import 'package:isave/screens/view.dart';

void main() async {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        "/": (BuildContext context) => const Home(),
        "/image_view": (BuildContext context) => const View(),
      },
      theme: theme,
      debugShowCheckedModeBanner: false,
      title: "isave",
      color: Colors.white,
    ),
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomNavigationCurrentIndex = 0;

  final QuickActions quickActions = const QuickActions();

  List<Widget> screens = [const Post(), const Profile()];

  @override
  void initState() {
    super.initState();

    quickActions.setShortcutItems(
      <ShortcutItem>[
        const ShortcutItem(
          type: 'post',
          localizedTitle: 'Post',
          icon: "post",
        ),
        const ShortcutItem(
          type: 'profile',
          localizedTitle: 'Profile',
          icon: "profile",
        )
      ],
    );

    quickActions.initialize((type) {
      if (type == 'post') {
        return;
      } else if (type == 'profile') {
        setState(() {
          _bottomNavigationCurrentIndex = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: header(context),
      body: IndexedStack(
        index: _bottomNavigationCurrentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavigationCurrentIndex,
        backgroundColor: Theme.of(context).backgroundColor,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        iconSize: 26.0,
        onTap: (int index) {
          setState(() {
            _bottomNavigationCurrentIndex = index;
          });
        },
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.collections_rounded,
            ),
            label: 'POST',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_rounded,
            ),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }
}
