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
        "/": (BuildContext context) => Home(),
        "/image_view": (BuildContext context) => View(),
      },
      theme: theme,
      debugShowCheckedModeBanner: false,
      title: "isave",
      color: Colors.white,
    ),
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
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

  List<Widget> screens = [Post(), Profile()];

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
      appBar: header(context),
      body: IndexedStack(
        index: _bottomNavigationCurrentIndex,
        children: screens,
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavigationCurrentIndex,
        backgroundColor: Theme.of(context).backgroundColor,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
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
        elevation: 10.0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.feed,
            ),
            label: 'post',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'profile',
          ),
        ],
      ),
    );
  }
}
