import 'dart:convert';

import 'package:bloc_boilerplate/api/api.dart';
import 'package:bloc_boilerplate/api/user_api.dart';
import 'package:bloc_boilerplate/blocs/bloc.dart';
import 'package:bloc_boilerplate/configs/config.dart';
import 'package:bloc_boilerplate/models/model.dart';
import 'package:bloc_boilerplate/utils/utils.dart';

class UserRepository {
  static Future<UserModel?> login({
    required String username,
    required String password,
  }) async {
    final Map<String, dynamic> params = {
      "username": username,
      "password": password,
    };
    final response = await UserApi.requestLogin(params);

    if (response.success) {
      return UserModel.fromJson(response.data);
    }
    AppBloc.messageBloc.add(OnMessage(message: response.message));
    return null;
  }

  static Future<UserModel?> loginDemo() async {
    await Future.delayed(const Duration(seconds: 1));
    return Application.demoUser;
  }

  ///Fetch api validToken
  static Future<bool> validateToken() async {
    final response = await UserApi.requestValidateToken();
    if (response.success) {
      return true;
    }
    AppBloc.messageBloc.add(OnMessage(message: response.message));
    return false;
  }

  ///Fetch api change Password
  static Future<bool> changePassword({required String password}) async {
    final Map<String, dynamic> params = {"password": password};
    final response = await UserApi.requestChangePassword(params);
    AppBloc.messageBloc.add(OnMessage(message: response.message));
    if (response.success) {
      return true;
    }
    return false;
  }

  ///Fetch api forgot Password
  static Future<bool> forgotPassword({required String email}) async {
    final Map<String, dynamic> params = {"email": email};
    final response = await UserApi.requestForgotPassword(params);
    AppBloc.messageBloc.add(OnMessage(message: response.message));
    if (response.success) {
      return true;
    }
    return false;
  }

  ///Fetch api register account
  static Future<bool> register({
    required String username,
    required String password,
    required String email,
  }) async {
    final Map<String, dynamic> params = {
      "username": username,
      "password": password,
      "email": email,
    };
    final response = await UserApi.requestRegister(params);
    AppBloc.messageBloc.add(OnMessage(message: response.message));
    if (response.success) {
      return true;
    }
    return false;
  }

  ///Fetch api forgot Password
  static Future<bool> changeProfile({
    required String name,
    required String email,
    required String url,
    required String description,
    int? imageID,
  }) async {
    Map<String, dynamic> params = {
      "name": name,
      "email": email,
      "url": url,
      "description": description,
    };
    if (imageID != null) {
      params['listar_user_photo'] = imageID;
    }
    final response = await UserApi.requestChangeProfile(params);
    AppBloc.messageBloc.add(OnMessage(message: response.message));

    //Case success
    if (response.success) {
      return true;
    }
    return false;
  }

  ///Save User
  static Future<void> saveUser({required UserModel user}) async {
    return await UtilSecureStorage.write(
      SecureStorage.user,
      jsonEncode(user.toJson()),
    );
  }

  ///Load User
  static Future<UserModel?> loadUser() async {
    final result = await UtilSecureStorage.read(SecureStorage.user);
    if (result != null) {
      return UserModel.fromJson(jsonDecode(result));
    }
    return null;
  }

  ///Fetch User
  static Future<UserModel?> fetchUser() async {
    final response = await UserApi.requestUser();
    if (response.success) {
      return UserModel.fromJson(response.data);
    }
    AppBloc.messageBloc.add(OnMessage(message: response.message));
    return null;
  }

  ///Delete User
  static Future<void> deleteUser() async {
    return await UtilSecureStorage.delete(SecureStorage.user);
  }
}
