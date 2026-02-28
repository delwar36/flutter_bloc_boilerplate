import '../configs/config.dart';
import '../models/model.dart';

class ConfigApi {
  static const String setting = "/v1/setting/init";
  static const String submitSetting = "/v1/place/form";
  static const String home = "/v1/home/init";

  ///Get Setting
  static Future<ResultApiModel> requestSetting() async {
    final result = await httpManager.get(url: setting);
    return ResultApiModel.fromJson(result);
  }

  ///Get Submit Setting
  static Future<ResultApiModel> requestSubmitSetting(params) async {
    final result = await httpManager.get(url: submitSetting, params: params);
    final convertResponse = {
      "success": result['countries'] != null,
      "data": result,
    };
    return ResultApiModel.fromJson(convertResponse);
  }

  ///Get Home
  static Future<ResultApiModel> requestHome() async {
    final result = await httpManager.get(url: home);
    return ResultApiModel.fromJson(result);
  }
}
