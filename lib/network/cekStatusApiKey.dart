
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:video_channels/helper/api_interface.dart';
import 'dart:async';

import 'package:video_channels/model/errorModel.dart';

class Network {
  static Future<LimitApi> check() async {
    final res = await http.get(ApiInterface.detailVideo + 'qKH4Wra4YHk' + '&key=' + ApiInterface.secretApi);

    if (res.statusCode == 200) {
      print(res.request.url.toString());
      return compute(limitApiFromJson, res.body);
    } else {
      return null;
    }
  }
}
