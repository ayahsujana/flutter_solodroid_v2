import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:video_channels/helper/api_interface.dart';
import 'package:video_channels/model/categoryModel.dart';
import 'package:video_channels/model/detailModel.dart';
import 'package:video_channels/model/videoModel.dart';


class RestApiProvider {
  Future<VideoModel> getPosts() async {
    final response =
        await http.get(ApiInterface.baseUrl + ApiInterface.getPosts);
    if (response.statusCode == 200) {
      print(response.request.url.toString());
      return compute(videoModelFromJson, response.body);
    } else {
      throw Exception("Failed to get data");
    }
  }

  Future<CategoryModel> getCategory() async {
    final response =
        await http.get(ApiInterface.baseUrl + ApiInterface.getCategoryIndex);
    if (response.statusCode == 200) {
      print(response.request.url.toString());
      return compute(categoryModelFromJson, response.body);
    } else {
      throw Exception("Failed to get data");
    }
  }

  Future<VideoModel> getPostsByCategory(int id) async {
    final response = await http.get(
        ApiInterface.baseUrl + ApiInterface.getCategoryPosts + id.toString());
    if (response.statusCode == 200) {
      print(response.request.url.toString());
      return compute(videoModelFromJson, response.body);
    } else {
      throw Exception("Failed to get data");
    }
  }

  Future<VideoModel> getSearchPosts(String query, int page) async {
    final response = await http
        .get(ApiInterface.baseUrl + ApiInterface.getSearchResult + query + '&page=' + page.toString());
    if (response.statusCode == 200) {
      print(response.request.url.toString());
      return compute(videoModelFromJson, response.body);
    } else {
      throw Exception("Failed to get data");
    }
  }

  Future<List<DetailVideo>> getVideoDetail(String id) async {
    final response = await http.get(ApiInterface.detailVideo + id + '&key=' + ApiInterface.secretApi);
    if (response.statusCode == 200) {
      print(response.request.url.toString());
      return compute(videoDetailListFromJson, response.body);
    } else {
      throw Exception("Failed to get data");
    }
  }
}
