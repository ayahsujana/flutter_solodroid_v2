import 'package:flutter/material.dart';
import 'package:video_channels/database/dbHelper.dart';
import 'package:video_channels/helper/ads.dart';
import 'package:video_channels/model/videoModel.dart';
import 'package:video_channels/screen/posts_detail_nolimit.dart';

class FavoritePosts extends StatefulWidget {
  @override
  _FavoritePostsState createState() => _FavoritePostsState();
}

class _FavoritePostsState extends State<FavoritePosts> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: VideosDatabaseLite.dbVideos.getAllVideos(),
      builder: (context, snapshot) {
        return _buildListVideos(snapshot?.data);
      },
    ));
  }

  Widget _buildListVideos(List<Post> snapshot) {
    try {
      if (snapshot.length == 0) {
        return Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.video_library,
                size: 50,
                color: Theme.of(context).accentColor,
              ),
            ),
            Text('No favorite video found.',
                style: TextStyle(
                    fontSize: 18.0, color: Theme.of(context).accentColor))
          ],
        ));
      } else {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            var vd = snapshot[i];
            return Container(
              width: 250,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Ads.showIntersAd();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostsDetailsNoLimits(vd)));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _getImageThumbnail(vd),
                      _getColumnText(vd),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      return SizedBox();
    }
  }

  Widget _getImageThumbnail(Post cv) {
    return Container(
      child: Stack(
        children: <Widget>[
          _getImageVideo(cv),
          _getTimeDuration(cv),
        ],
      ),
    );
  }

  Widget _getImageVideo(Post cv) {
    return Container(
      width: 300.0,
      height: 150.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: FadeInImage(
          image: NetworkImage(
              "https://img.youtube.com/vi/" + cv.videoId + "/0.jpg"),
          fit: BoxFit.cover,
          placeholder: AssetImage('assets/images/loading.gif'),
        ),
      ),
    );
  }

  Widget _getTimeDuration(Post cv) {
    return Positioned(
      right: 10.0,
      bottom: 16.0,
      child: Container(
        height: 25.0,
        width: 40.0,
        color: Colors.black,
        child: Center(
            child: Text(cv.videoDuration,
                style: TextStyle(fontSize: 14.0, color: Colors.white))),
      ),
    );
  }

  Widget _getColumnText(Post cv) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(cv.videoTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle),
            SizedBox(
              height: 16.0,
            ),
            Text(cv.categoryName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.w600),),
          ],
        ),
      ),
    );
  }
}
