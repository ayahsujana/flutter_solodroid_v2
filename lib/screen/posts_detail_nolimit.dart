import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:video_channels/database/dbHelper.dart';
import 'package:video_channels/helper/ads.dart';
import 'package:video_channels/helper/string.dart';
import 'package:video_channels/model/videoModel.dart';
import 'package:video_channels/screen/search_posts.dart';
import 'package:youtube_player/youtube_player.dart';

class PostsDetailsNoLimits extends StatefulWidget {
  final Post items;
  PostsDetailsNoLimits(this.items);
  @override
  _PostsDetailsNoLimitsState createState() => _PostsDetailsNoLimitsState();
}

class _PostsDetailsNoLimitsState extends State<PostsDetailsNoLimits> {
  @override
  void dispose() {
    SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }

  @override
  void initState() {
    VideosDatabaseLite.dbVideos.getVideo(widget.items.videoId).then((video) {
      setState(() {
        widget.items.favorite = video.favorite;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(child: _buildBody(widget.items)));
  }

  Widget _buildBody(Post items) {
    // var videoThumbnail =
    //     "https://i.ytimg.com/vi/" + items.videoId + "/hqdefault.jpg";
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          youTubePlayer(items),
          _buildTextVideo(items),
          Padding(
            padding: EdgeInsets.all(8),
            child: Ads.mediumBanner(),
          )
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

  Widget _buildTextVideo(Post items) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(items.videoTitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Divider(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildIconTextCount(
                    Icons.security, "Terms of Use", Colors.red, null),
                buildIconTextCount(
                    !widget.items.favorite
                        ? Icons.favorite_border
                        : Icons.favorite,
                    "Favorite",
                    Colors.pink,
                    _fav),
                buildIconTextCount(Icons.share, "Share", Colors.blue, _share),
                //buildIconTextCount(Icons.search, "Search", Colors.yellow, _search),
              ],
            ),
          ),
          Divider(
            height: 5,
          ),
        ]);
  }

  Widget buildIconTextCount(
      IconData icon, String text, Color color, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Icon(icon, size: 30, color: color),
          ),
          Text(text, style: Theme.of(context).textTheme.body2)
        ],
      ),
    );
  }

  _fav() {
    showLongToast(!widget.items.favorite
        ? 'Add to favorite success!'
        : 'Remove from favorite success!');
  }

  _share() async {
    await Share.share(
        "Hey! I just watching ${widget.items.videoTitle} on ${Strings.appName}, Download now for free on playstore and share it with your friends. https://play.google.com/store/apps/details?id=${Strings.packageName}");
  }

  _search() {
    showSearch(context: context, delegate: VideosSearch());
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
}
