import 'package:bloc_boilerplate/models/model.dart';
import 'package:bloc_boilerplate/utils/utils.dart';

class Application {
  static const bool debug = false;
  static const String version = '1.0.0';
  static const String domain = 'API_BASE_URL';
  static const String googleAPI = 'GOOGLE_API_KEY';
  static DeviceModel? device;

  static Future<void> setDevice() async {
    device = await UtilOther.getDeviceInfo();
  }

  static Future<void> setDeviceToken() async {
    device!.token = await UtilOther.getDeviceToken();
  }

  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
