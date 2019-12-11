import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_channels/helper/ads.dart';
import 'package:video_channels/model/videoModel.dart';
import 'package:video_channels/screen/posts_detail.dart';

class ItemListVideos extends StatelessWidget {
  final Post items;
  ItemListVideos(this.items);
  @override
  Widget build(BuildContext context) {
    var videoThumbnail =
        "https://i.ytimg.com/vi/" + items.videoId + "/hqdefault.jpg";
    return GestureDetector(
      onTap: () {
        Ads.showIntersAd();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PostsDetail(items)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Hero(
                    tag: items.vid,
                    child: CachedNetworkImage(
                      imageUrl: videoThumbnail,
                      placeholder: (context, url) => Image.asset(
                        'assets/images/loading.gif',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image.network(
                        'https://vignette.wikia.nocookie.net/the-weeb-squad/images/c/c9/Error-404.png',
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                height: 40,
                width: 65,
                child: Card(
                  margin: EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      items.videoDuration,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
