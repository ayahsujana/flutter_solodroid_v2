

import 'package:video_channels/model/base_model.dart';
import 'package:video_channels/network/repo.dart';

abstract class BaseBloc<T extends BaseModel> {
  final repository = Repo();

  dispose() {}
}