import 'package:flutter/material.dart';
import 'package:video_channels/bloc/bloc.dart';
import 'package:video_channels/helper/ads.dart';
import 'package:video_channels/model/categoryModel.dart';
import 'package:video_channels/widget/widget_getCatImages.dart';

class CategoryPosts extends StatefulWidget {
  @override
  _CategoryPostsState createState() => _CategoryPostsState();
}

class _CategoryPostsState extends State<CategoryPosts>
    with AutomaticKeepAliveClientMixin<CategoryPosts> {
  final catPosts = VideoCategoryBloc();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    catPosts.getCategorys();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Ads.interstitialLoad();
    return StreamBuilder(
      stream: catPosts.getCategory,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text("Connection Not Found"),
            );
          case ConnectionState.waiting:
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.yellow),
            ));

          default:
            if (snapshot.hasError) {
              return Center(
                child: Text("Error : ${snapshot.error}"),
              );
            }

            return CategoryListBuilder(snapshot.data);
        }
      },
    );
  }
}

class CategoryListBuilder extends StatelessWidget {
  final CategoryModel items;
  CategoryListBuilder(this.items);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.categories.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, i) {
        var itemPosts = items.categories[i];
        return ItemListCategory(itemPosts);
      },
    );
  }
}
