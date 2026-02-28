import 'package:bloc_boilerplate/api/api.dart';
import 'package:bloc_boilerplate/api/config_api.dart';
import 'package:bloc_boilerplate/models/model.dart';

class ConfigRepository {
  ///Fetch api setting
  static Future<ResultApiModel> fetchSetting() async {
    return await ConfigApi.requestSetting();
  }

  ///Fetch api submit setting
  static Future<ResultApiModel> fetchSubmitSetting({
    Map<String, dynamic>? params,
  }) async {
    return await ConfigApi.requestSubmitSetting(params);
  }

  ///Fetch api home
  static Future<ResultApiModel> fetchHome() async {
    return await ConfigApi.requestHome();
  }
}
