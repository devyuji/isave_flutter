import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

// custom
import 'package:isave/provider/update_state.dart';
import 'package:isave/provider/downloader_state.dart';
import 'package:isave/utils/notification.dart';
import 'package:isave/screens/view.dart';
import 'package:isave/provider/preview_state.dart';
import 'package:isave/theme.dart';
import 'package:isave/screens/home/index.dart';

const debug = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(debug: debug);

  await LocalNotification.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PreviewState()),
        ChangeNotifierProvider(create: (_) => UpdateState()),
        ChangeNotifierProvider(create: (_) => DownloaderState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Provider.of<UpdateState>(context, listen: false).checkUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {"/": (_) => const Home(), "/view": (_) => const View()},
      themeMode: ThemeMode.system,
      theme: CustomTheme.light(),
      darkTheme: CustomTheme.dark(),
      debugShowCheckedModeBanner: debug,
      title: "isave",
      color: Colors.white,
    );
  }
}
