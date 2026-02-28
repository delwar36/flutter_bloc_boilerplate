import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static FlutterSecureStorage? instance;

  static const String token = 'token';
  static const String account = 'account';
  static const String password = 'password';
  static const String user = 'user';

  static Future<void> setSecureStorage() async {
    instance = const FlutterSecureStorage();
  }

  ///Singleton factory
  static final SecureStorage _instance = SecureStorage._internal();

  factory SecureStorage() {
    return _instance;
  }

  SecureStorage._internal();
}
