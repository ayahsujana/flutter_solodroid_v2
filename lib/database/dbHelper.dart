
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:video_channels/model/videoModel.dart';

class VideosDatabaseLite{
  VideosDatabaseLite._();

  static final VideosDatabaseLite dbVideos = VideosDatabaseLite._();
  Database _dtBase;

  Future<Database> get database async {
    if (_dtBase != null) return _dtBase;
    _dtBase = await getDatabaseInstance();
    return _dtBase;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "Videos.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE video ("
          "vid integer primary key,"
          "video_title TEXT,"
          "video_url TEXT,"
          "video_id TEXT,"
          "video_thumbnail TEXT,"
          "video_duration TEXT,"
          "video_description TEXT,"
          "video_type TEXT,"
          "category_name TEXT,"
          "fav BIT"
          ")");
    });
  }

  Future<Post> getVideo(String vId) async {
    final db = await database;
    var res = await db.query("video", where: "video_id = ?", whereArgs: [vId]);
    if (res.length == 0) return null;
    return Post.fromMap(res[0]);
  }

  addVideoToDatabase(Post video) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(vid)+1 as vid FROM video");
    int id = table.first["vid"];
    video.vid = id ;
    var raw = await db.insert(
      "video",
      video.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<List<Post>> getAllVideos() async {
    final db = await database;
    var response = await db.query("video");
    List<Post> list = response.map((c) => Post.fromMap(c)).toList();
    return list;
  }

  deleteVideoByInt(int id) async {
    final db = await database;
    return db.delete("video", where: "vid = ?", whereArgs: [id]);
  }

  deleteVideoByString(String id) async {
    final db = await database;
    return db.delete("video", where: "video_id = ?", whereArgs: [id]);
  }

  // updateMovies(VidModel movie) async {
  //   final db = await database;
  //   var response = await db.update("video", movie.toMap(),
  //       where: "id = ?", whereArgs: [movie.id]);
  //   return response;
  // }
}