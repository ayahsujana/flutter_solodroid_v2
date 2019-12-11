

import 'package:video_channels/model/categoryModel.dart';
import 'package:video_channels/model/detailModel.dart';
import 'package:video_channels/model/videoModel.dart';
import 'package:video_channels/network/rest_api.dart';

class Repo {
  final apiInterface = RestApiProvider();

  Future<VideoModel> getPosts() => apiInterface.getPosts();
  Future<CategoryModel> getCategory() => apiInterface.getCategory();
  Future<VideoModel> getPostsByCategory(int id) => apiInterface.getPostsByCategory(id);
  Future<VideoModel> getSearchPosts(String query, int page) => apiInterface.getSearchPosts(query, page);
  Future<List<DetailVideo>> getVideoDetail(String id) => apiInterface.getVideoDetail(id);
}