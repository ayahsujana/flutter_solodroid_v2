import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:video_channels/model/videoModel.dart';
import 'package:video_channels/network/repo.dart';
import 'package:video_channels/widget/widget_getPostImages.dart';

class SearchPostsLoadMore extends StatefulWidget {
  VideoModel post;
  String query;
  int page;
  SearchPostsLoadMore(this.post, this.query, this.page);
  @override
  _SearchPostsLoadMoreState createState() => _SearchPostsLoadMoreState();
}

class _SearchPostsLoadMoreState extends State<SearchPostsLoadMore> {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  final _repo = Repo();
  int _page = 1;
  bool loadMore = true;
  List<VideoModel> post;
  var query = '';
  @override
  void initState() {
    query = widget.query;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: new EasyRefresh(
      key: _easyRefreshKey,
      behavior: ScrollOverBehavior(),
      refreshFooter: ClassicsFooter(
        key: _footerKey,
        bgColor: Colors.transparent,
        textColor: Colors.white,
        noMoreText: "Load finished",
        showMore: true,
      ),
      child: ListView.builder(
        itemCount: widget.post.posts.length,
        itemBuilder: (context, i) {
          var itemPosts = widget.post.posts[i];
          return ItemListVideos(itemPosts);
        },
      ),
      loadMore: () async {
        await new Future.delayed(const Duration(seconds: 1), () {
          widget.page = widget.page + 1;
          _repo
              .getSearchPosts(query, widget.page)
              .then((post) => showMusic(post, loadMore))
              .catchError((onError) => showError(onError));
        });
      },
    ));
  }

  showMusic(VideoModel post, bool loadMore) {
    if (loadMore) {
      setState(() {
        widget.post.posts.addAll(post.posts);
      });
    } else {
      setState(() {
        widget.post.posts = post.posts;
        widget.post.posts.addAll(post.posts);
      });
    }
  }

  showError(onError) {
    print(onError);
    if (onError is FetchDataException) {
      print("Error: ${onError.code()}");
    }
  }
}

class FetchDataException implements Exception {
  String _message;
  int _code;

  FetchDataException(this._message, this._code);

  String toString() {
    return "Exception: $_message/$_code";
  }

  int code() {
    return _code;
  }
}
