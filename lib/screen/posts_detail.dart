import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_channels/bloc/bloc.dart';
import 'package:video_channels/database/dbHelper.dart';
import 'package:video_channels/helper/ads.dart';
import 'package:video_channels/helper/screen.dart';
import 'package:video_channels/model/detailModel.dart';
import 'package:video_channels/model/videoModel.dart';
import 'package:video_channels/network/cekStatusApiKey.dart';
import 'package:video_channels/screen/posts_detail_nolimit.dart';
import 'package:youtube_player/youtube_player.dart';

class PostsDetail extends StatefulWidget {
  final Post items;

  const PostsDetail(this.items);
  @override
  _PostsDetailState createState() => _PostsDetailState();
}

class _PostsDetailState extends State<PostsDetail> {
  final detailPosts = DetailPostsBloc();

  @override
  void initState() {
    detailPosts.getDetailPostss(widget.items.videoId);
    VideosDatabaseLite.dbVideos.getVideo(widget.items.videoId).then((video) {
      setState(() {
        widget.items.favorite = video.favorite;
      });
    });
    Screen.setPortrait();
    super.initState();
  }

  startToGo(Function() navigate) {
    var _duration = Duration(milliseconds: 1000);
    return Timer(_duration, navigateTo);
  }

  navigate() async {
    await navigateTo();
  }

  navigateTo() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PostsDetailsNoLimits(widget.items)));
  }

  @override
  Widget build(BuildContext context) {
    Ads.interstitialLoad();
    Network.check().then((error) {
      print('status error = $error');
      if (error == null) {
        startToGo(navigate);
      }
    });
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black, body: _buildWidgetBody(widget.items)),
    );
  }

  Widget _buildWidgetBody(Post items) {
    return StreamBuilder(
      stream: detailPosts.getDetailPosts,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text("Connection Not Found"),
            );
          case ConnectionState.waiting:
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.amber),
            ));

          default:
            print("aku di snapshot has error");
            if (snapshot.hasError) {
              return Center(
                child: Text("Error : ${snapshot.error}"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _buildItemsPosts(snapshot.data[index]);
              },
            );
        }
      },
    );
  }

  Widget _buildItemsPosts(DetailVideo items) {
    return Container(
      child: Column(
        children: <Widget>[
          youTubePlayer(widget.items),
          Ads.bannerAds(),
          textDetailVideo(items),
        ],
      ),
    );
  }

  Widget youTubePlayer(Post items) {
    return YoutubePlayer(
      context: context,
      source: items.videoId,
      quality: YoutubeQuality.MEDIUM,
      aspectRatio: 16 / 9,
      autoPlay: false,
      reactToOrientationChange: true,
      controlsTimeOut: Duration(seconds: 3),
      playerMode: YoutubePlayerMode.DEFAULT,
      onError: (error) {
        print(error);
      },
      onVideoEnded: () {
        Ads.showIntersAd();
      },
    );
  }

  Widget textDetailVideo(DetailVideo items) {
    String views = viewCount(items.view);
    String likes = thumbUp(items.like);
    String unLikes = thumbDown(items.disLike);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            items.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 16.0, top: 8.0),
          child:
              Text(views + ' views', style: Theme.of(context).textTheme.body2),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildIconTextCount(
                  !widget.items.favorite
                      ? Icons.favorite_border
                      : Icons.favorite,
                  "Favorite",
                  _fav),
              buildIconTextCount(Icons.thumb_up, likes, null),
              buildIconTextCount(Icons.thumb_down, unLikes, null),
              //buildIconTextCount(Icons.favorite_border, "Favorite", null),
            ],
          ),
        ),
        Divider(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(items.description,
              style: Theme.of(context).textTheme.caption),
        )
      ],
    );
  }

  _fav() {
    showLongToast(!widget.items.favorite
        ? 'Add to favorite success!'
        : 'Remove from favorite success!');
  }

  Widget buildIconTextCount(IconData icon, String text, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Icon(icon, size: 30, color: Colors.grey),
          ),
          Text(text, style: Theme.of(context).textTheme.body2)
        ],
      ),
    );
  }

  String viewCount(String view) {
    int views = int.parse(view);
    String viewStr = views.toString();
    int length = viewStr.length;

    String sign;

    if ((views % 1000) == views) {
      return views.toString();
    }

    for (int i = 3; i < length; i = i + 3) {
      int power = pow(10, i);
      if (length > i && (length - i) <= 3) {
        double f = views / power;
        if (power == pow(10, 3)) {
          sign = "K";
        } else if (power == pow(10, 6)) {
          sign = "M";
        } else if (power == pow(10, 9)) {
          sign = "B";
        }
        return f.round().toString() + sign;
      }
    }
    return views.toString() == null ? '0' : views;
  }

  String thumbDown(String unLike) {
    int thumbDowns = int.parse(unLike);
    String thumbDownStr = thumbDowns.toString();
    int length = thumbDownStr.length;

    String sign;

    if ((thumbDowns % 1000) == thumbDowns) {
      return thumbDowns.toString();
    }

    for (int i = 3; i < length; i = i + 3) {
      int power = pow(10, i);
      if (length > i && (length - i) <= 3) {
        double f = thumbDowns / power;
        if (power == pow(10, 3)) {
          sign = "K";
        } else if (power == pow(10, 6)) {
          sign = "M";
        } else if (power == pow(10, 9)) {
          sign = "B";
        }
        return f.round().toString() + sign;
      }
    }
    return thumbDowns.toString() == null ? '0' : thumbDowns;
  }

  String thumbUp(String likes) {
    int thumbUps = int.parse(likes);
    String thumbUpStr = thumbUps.toString();
    int length = thumbUpStr.length;

    String sign;

    if ((thumbUps % 1000) == thumbUps) {
      return thumbUps.toString();
    }

    for (int i = 3; i < length; i = i + 3) {
      int power = pow(10, i);
      if (length > i && (length - i) <= 3) {
        double f = thumbUps / power;
        if (power == pow(10, 3)) {
          sign = "K";
        } else if (power == pow(10, 6)) {
          sign = "M";
        } else if (power == pow(10, 9)) {
          sign = "B";
        }
        return f.round().toString() + sign;
      }
    }
    return thumbUps.toString() == null ? '0' : thumbUps;
  }

  showLongToast(String pesan) {
    Fluttertoast.showToast(msg: "$pesan", toastLength: Toast.LENGTH_SHORT);
    setState(() {
      widget.items.favorite = !widget.items.favorite;
      //RewardedVideoAd.instance.show();
      _addToFavorite();
    });
  }

  _addToFavorite() {
    widget.items.favorite
        ? VideosDatabaseLite.dbVideos.addVideoToDatabase(new Post(
            vid: widget.items.vid,
            videoTitle: widget.items.videoTitle.toString(),
            videoUrl: widget.items.videoUrl.toString(),
            videoId: widget.items.videoId.toString(),
            videoThumbnail: widget.items.videoThumbnail.toString(),
            videoDuration: widget.items.videoDuration.toString(),
            videoDescription: widget.items.videoDescription.toString(),
            videoType: widget.items.videoType.toString(),
            categoryName: widget.items.categoryName.toString(),
            favorite: widget.items.favorite))
        : widget.items.favorite == true
            ? VideosDatabaseLite.dbVideos.deleteVideoByInt(widget.items.vid)
            : VideosDatabaseLite.dbVideos
                .deleteVideoByString(widget.items.videoId);
  }

  subscribe() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Sorry!! this function under develop.",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                        child: Text("Okey!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
