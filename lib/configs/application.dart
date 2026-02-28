import 'package:bloc_boilerplate/models/model.dart';
import 'package:bloc_boilerplate/utils/utils.dart';

class Application {
  static const bool debug = false;
  static const String version = '1.0.0';
  static const String domain = 'https://api.example.com';
  static const String googleAPI = 'GOOGLE_API_KEY';
  static DeviceModel? device;
  static final demoUser = UserModel(
    id: 1,
    name: "Demo User",
    nickname: "demo",
    password: "demo123",
    image: "https://i.pravatar.cc/150?u=demo",
    url: "https://google.com",
    level: 1,
    description: "This is a demo account",
    tag: "Demo",
    rate: 5.0,
    comment: 2,
    total: 3,
    token: "demo_token",
    email: "demo@example.com",
  );

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
