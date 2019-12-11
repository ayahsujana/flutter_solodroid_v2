import 'dart:convert';

VideoModel videoModelFromJson(String str) =>
    VideoModel.fromJson(json.decode(str));

class VideoModel {
  String status;
  int count;
  int countTotal;
  int pages;
  List<Post> posts;

  VideoModel({
    this.status,
    this.count,
    this.countTotal,
    this.pages,
    this.posts,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        status: json["status"],
        count: json["count"],
        countTotal: json["count_total"],
        pages: json["pages"],
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
      );
}

class Post {
  int vid;
  int catId;
  String videoTitle;
  String videoUrl;
  String videoId;
  String videoThumbnail;
  String videoDuration;
  String videoDescription;
  String videoType;
  String size;
  int totalViews;
  DateTime dateTime;
  String categoryName;
  bool favorite;

  Post({
    this.vid,
    this.catId,
    this.videoTitle,
    this.videoUrl,
    this.videoId,
    this.videoThumbnail,
    this.videoDuration,
    this.videoDescription,
    this.videoType,
    this.size,
    this.totalViews,
    this.dateTime,
    this.categoryName,
    this.favorite,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        vid: json["vid"],
        catId: json["cat_id"],
        videoTitle: json["video_title"],
        videoUrl: json["video_url"],
        videoId: json["video_id"],
        videoThumbnail: json["video_thumbnail"],
        videoDuration: json["video_duration"],
        videoDescription: json["video_description"],
        videoType: json["video_type"],
        size: json["size"],
        totalViews: json["total_views"],
        dateTime: DateTime.parse(json["date_time"]),
        categoryName: json["category_name"],
        favorite: false,
      );

  factory Post.fromMap(Map<String, dynamic> json) => new Post(
        vid: json["vid"],
        videoTitle: json["video_title"],
        videoUrl: json["video_url"],
        videoId: json["video_id"],
        videoThumbnail: json["video_thumbnail"],
        videoDuration: json["video_duration"],
        videoDescription: json["video_description"],
        videoType: json["video_type"],
        categoryName: json["category_name"],
        favorite: json["fav"] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() => {
        "vid": vid,
        "video_title": videoTitle,
        "video_url": videoUrl,
        "video_id": videoId,
        "video_thumbnail": videoThumbnail,
        "video_duration": videoDuration,
        "video_description": videoDescription,
        "video_type": videoType,
        "category_name": categoryName,
        "fav": favorite,
      };
}
