import 'package:bloc_boilerplate/configs/config.dart';

class UtilSecureStorage {
  static Future<void> delete(String key) {
    return SecureStorage.instance!.delete(key: key);
  }

  static Future<void> deleteAll() {
    return SecureStorage.instance!.deleteAll();
  }

  static Future<String?> read(String key) {
    return SecureStorage.instance!.read(key: key);
  }

  static Future<Map<String, String>> readAll() {
    return SecureStorage.instance!.readAll();
  }

  static Future<void> write(String key, String value) {
    return SecureStorage.instance!.write(key: key, value: value);
  }

  static Future<bool> containsKey(String key) {
    return SecureStorage.instance!.containsKey(key: key);
  }

  ///Singleton factory
  static final _instance = UtilSecureStorage._internal();

  factory UtilSecureStorage() {
    return _instance;
  }

  UtilSecureStorage._internal();
}
