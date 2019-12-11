import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_channels/helper/ads.dart';
import 'package:video_channels/helper/api_interface.dart';
import 'package:video_channels/model/categoryModel.dart';
import 'package:video_channels/screen/category_posts.dart';

class ItemListCategory extends StatelessWidget {
  final Category catItem;
  ItemListCategory(this.catItem);
  @override
  Widget build(BuildContext context) {
    var catImage =
        ApiInterface.baseUrl + 'upload/category/' + catItem.categoryImage;
    return Container(
      height: 200,
      width: 250,
      child: GestureDetector(
        onTap: () {
          Ads.showIntersAd();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  CategoryByIdPosts(catItem.cid, catItem.categoryName)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(12),
                  height: 125,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CachedNetworkImage(
                      imageUrl: catImage,
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
                Positioned(
                  right: 16,
                  top: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    maxRadius: 18,
                    child: Text(
                      catItem.videoCount.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Text(catItem.categoryName,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
