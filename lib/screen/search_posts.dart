import 'package:flutter/material.dart';
import 'package:video_channels/network/repo.dart';
import 'package:video_channels/widget/more_serach_posts.dart';

class VideosSearch extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      color: Colors.white,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchPosts = Repo();
    return FutureBuilder(
      future: searchPosts.getSearchPosts(query, 1),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text("Connection Not Found"),
            );
          case ConnectionState.waiting:
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );

          default:
            if (snapshot.hasError) {
              return Center(
                child: Text("Error : ${snapshot.error}"),
              );
            }
            //Post video = snapshot.data;

            // VideoModel mVideo = snapshot.data;
            // print("status : $mVideo");
            return SearchPostsLoadMore(snapshot.data, query, 1);
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.search,
            size: 60.0,
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            "Search your video favorite",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          )
        ],
      )),
    );
  }
}
