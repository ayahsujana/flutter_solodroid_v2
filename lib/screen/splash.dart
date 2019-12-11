import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_channels/helper/colorTextStyle.dart';
import 'package:video_channels/helper/screen.dart';
import 'package:video_channels/helper/string.dart';
import 'package:video_channels/screen/homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

const int splash_time = 5;

class _SplashScreenState extends State<SplashScreen> {
  

  Future<Timer> loadingSplash() async {
    return Timer(Duration(seconds: splash_time), doneLoading);
  }

  doneLoading() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePagePosts()));
  }

  @override
  void initState() {
    super.initState();
    Screen.hideSystemBars();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    loadingSplash();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black,
      body: Material(
          child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(colors: [
                Colors.black,
                Colors.black87,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  Strings.myIcon,
                  width: 150,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              ),
              Text(Strings.appName,
                  style: textStyle30NoBold(kBgColor),
                  textAlign: TextAlign.center)
            ],
          ),
        ],
      )),
    );
  }

}
