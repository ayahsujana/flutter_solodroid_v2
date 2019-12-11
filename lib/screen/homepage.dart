import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:video_channels/helper/ads.dart';
import 'package:video_channels/helper/api_interface.dart';
import 'package:video_channels/helper/string.dart';
import 'package:video_channels/model/videoModel.dart';
import 'package:video_channels/screen/posts_detail.dart';

import 'category_index.dart';
import 'favorite_posts.dart';

class HomePagePosts extends StatefulWidget {
  @override
  _HomePagePostsState createState() => _HomePagePostsState();
}

class _HomePagePostsState extends State<HomePagePosts> {
  VideoModel videoModel;

  void fetchNowPlayingMovies() async {
    final response =
        await http.get(ApiInterface.baseUrl + ApiInterface.getPosts);
    final decodeJson = jsonDecode(response.body);
    _rebuildDecode(decodeJson);
  }

  _rebuildDecode(dynamic json) {
    setState(() {
      videoModel = VideoModel.fromJson(json);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNowPlayingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitDialog,
      child: Scaffold(
        backgroundColor: Colors.black,
        // appBar: AppBar(),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black,
                title: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text("New Videos Added",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                expandedHeight: 250,
                floating: false,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: _buildCarouselSlider()),
                  ),
                
              ),
            ];
          },
          body: Container(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 12.0),
                  child: Text(
                    'Category',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  child: CategoryPosts(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 12.0),
                  child: Text(
                    'Favorite',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
                Container(
                  height: 250,
                  width: double.infinity,
                  child: FavoritePosts(),
                ),Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 12.0),
                  child: Text(
                    'Advertisment',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white),
                  ),
                ),
                Container(
                  height: 250,
                  width: double.infinity,
                  child: Ads.mediumBanner(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() => CarouselSlider(
        items: videoModel == null
            ? <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                )
              ]
            : videoModel.posts
                .map((videoItem) => _buildVideoItems(videoItem))
                .toList(),
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 2.0,
        autoPlayInterval: Duration(seconds: 10),
      );

  Widget _buildVideoItems(Post postsItem) {
    var videoThumbnail =
        "https://i.ytimg.com/vi/" + postsItem.videoId + "/hqdefault.jpg";
    return Container(
      margin: EdgeInsets.all(5),
      color: Colors.black,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostsDetail(postsItem)));
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              CachedNetworkImage(
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
                width: 1000.0,
              ),
              Positioned(
                child: Container(
                  width: 500,
                  child: Center(
                    child: Card(
                      color: Colors.black38,
                      child: Text(
                        postsItem.videoTitle,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 5,
                bottom: 5,
                child: Container(
                  height: 40,
                  width: 75,
                  child: Card(
                    margin: EdgeInsets.all(8),
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        postsItem.videoDuration,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 5,
                bottom: 5,
                child: Container(
                  child: Center(
                    child: Card(
                      color: Colors.black54,
                      child: Text(
                        postsItem.categoryName,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> showExitDialog() {
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
                    padding: EdgeInsets.all(16.0),
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/icon.png',
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          Strings.appName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Thanks for using app ${Strings.appName}, I hope you enjoy and like it. Don't forget to give us your 5 star and review for support us!\n\n Really want to close this app??",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
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
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
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
          );
        });
  }
}
