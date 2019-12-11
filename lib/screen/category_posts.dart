import 'package:flutter/material.dart';
import 'package:video_channels/bloc/bloc.dart';
import 'package:video_channels/model/videoModel.dart';
import 'package:video_channels/widget/widget_getPostCatImage.dart';

class CategoryByIdPosts extends StatefulWidget {
  final int catId;
  final String catName;
  CategoryByIdPosts(this.catId, this.catName);
  @override
  _CategoryByIdPostsState createState() => _CategoryByIdPostsState();
}

class _CategoryByIdPostsState extends State<CategoryByIdPosts> {
  final postsByCategory = PostsByCategoryBloc();

  @override
  void initState() {
    postsByCategory.getPostsByCategorys(widget.catId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
        ),
        title: Text(widget.catName),
      ),
      body: StreamBuilder(
        stream: postsByCategory.getPostsByCategory,
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
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error : ${snapshot.error}"),
                );
              }

              return PostByListBuilder(snapshot.data);
          }
        },
      ),
    );
  }
}

class PostByListBuilder extends StatelessWidget {
  final VideoModel items;

  const PostByListBuilder(this.items);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.posts.length,
      itemBuilder: (context, i) {
        var itemPosts = items.posts[i];
        return ItemListCategoryVideos(itemPosts);
      },
    );
  }
}
