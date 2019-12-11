import 'package:rxdart/rxdart.dart';
import 'package:video_channels/model/categoryModel.dart';
import 'package:video_channels/model/detailModel.dart';
import 'package:video_channels/model/videoModel.dart';

import 'base_bloc.dart';

class VideoPostsBloc extends BaseBloc {
  final video = BehaviorSubject<VideoModel>();

  Stream<VideoModel> get getPosts => video.stream;

  getPostss() async {
    VideoModel videoList = await repository.getPosts();
    video.sink.add(videoList);
  }

  @override
  dispose() {
    video.close();
    super.dispose();
  }
}

class VideoCategoryBloc extends BaseBloc {
  final category = BehaviorSubject<CategoryModel>();

  Stream<CategoryModel> get getCategory => category.stream;

  getCategorys() async {
    CategoryModel videoList = await repository.getCategory();
    category.sink.add(videoList);
  }

  @override
  dispose() {
    category.close();
    super.dispose();
  }
}

class PostsByCategoryBloc extends BaseBloc {
  final byCategory = BehaviorSubject<VideoModel>();

  Stream<VideoModel> get getPostsByCategory => byCategory.stream;

  getPostsByCategorys(int id) async {
    VideoModel videoList = await repository.getPostsByCategory(id);
    byCategory.sink.add(videoList);
  }

  @override
  dispose() {
    byCategory.close();
    super.dispose();
  }
}

class SearchPostsBloc extends BaseBloc {
  final search = BehaviorSubject<VideoModel>();

  Stream<VideoModel> get getSearchPosts => search.stream;

  getSearchPostss(String query, int page) async {
    VideoModel videoList = await repository.getSearchPosts(query,page);
    search.sink.add(videoList);
  }

  @override
  dispose() {
    search.close();
    super.dispose();
  }
}

class DetailPostsBloc extends BaseBloc {
  final detail = BehaviorSubject<List<DetailVideo>>();

  Stream<List<DetailVideo>> get getDetailPosts => detail.stream;

  getDetailPostss(String id) async {
    List<DetailVideo> videoList = await repository.getVideoDetail(id);
    detail.sink.add(videoList);
  }

  @override
  dispose() {
    detail.close();
    return super.dispose();
  }
}
