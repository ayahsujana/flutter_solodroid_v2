import 'package:flutter/material.dart';
import 'package:screen/screen.dart' as screen;
import 'package:video_channels/helper/screen.dart';
import 'package:youtube_player/youtube_player.dart';

class PostsVideoPlayer extends StatefulWidget {
  final String videoId;
  PostsVideoPlayer(this.videoId);
  @override
  _PostsVideoPlayerState createState() => _PostsVideoPlayerState();
}

class _PostsVideoPlayerState extends State<PostsVideoPlayer> {
  @override
  void dispose() {
    Screen.showSystemBars();
    Screen.setPortrait();
    screen.Screen.keepOn(false);
    super.dispose();
  }

  @override
  void initState() {
    Screen.hideSystemBars();
    Screen.setLandscape();
    screen.Screen.keepOn(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _backToDetail, child: youTubePlayer());
  }

  Widget youTubePlayer() {
    return YoutubePlayer(
      context: context,
      source: widget.videoId,
      quality: YoutubeQuality.MEDIUM,
      aspectRatio: 16 / 9,
      autoPlay: false,
      reactToOrientationChange: true,
      controlsTimeOut: Duration(seconds: 3),
      playerMode: YoutubePlayerMode.DEFAULT,
      onError: (error) {
        print(error);
      },
      onVideoEnded: () {},
    );
  }

  Future<bool> _backToDetail() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Container(
              width: 300,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Do you want to exit from video??",
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          textColor: Colors.black,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FlatButton(
                          textColor: Colors.black,
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Text("Yes",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
