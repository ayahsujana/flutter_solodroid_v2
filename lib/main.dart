import 'package:flutter/material.dart';
import 'package:video_channels/helper/ads.dart';
import 'package:video_channels/helper/string.dart';
import 'package:video_channels/screen/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Ads.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      theme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}
