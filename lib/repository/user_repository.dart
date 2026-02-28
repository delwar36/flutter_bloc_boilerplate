import 'dart:convert';

import 'package:bloc_boilerplate/api/api.dart';
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
    final response = await apiHandler.requestLogin(params);

    if (response.success) {
      return UserModel.fromJson(response.data);
    }
    AppBloc.messageBloc.add(OnMessage(message: response.message));
    return null;
  }

  ///Fetch api validToken
  static Future<bool> validateToken() async {
    final response = await apiHandler.requestValidateToken();
    if (response.success) {
      return true;
    }
    AppBloc.messageBloc.add(OnMessage(message: response.message));
    return false;
  }

  ///Fetch api change Password
  static Future<bool> changePassword({required String password}) async {
    final Map<String, dynamic> params = {"password": password};
    final response = await apiHandler.requestChangePassword(params);
    AppBloc.messageBloc.add(OnMessage(message: response.message));
    if (response.success) {
      return true;
    }
    return false;
  }

  ///Fetch api forgot Password
  static Future<bool> forgotPassword({required String email}) async {
    final Map<String, dynamic> params = {"email": email};
    final response = await apiHandler.requestForgotPassword(params);
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
    final response = await apiHandler.requestRegister(params);
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
    final response = await apiHandler.requestChangeProfile(params);
    AppBloc.messageBloc.add(OnMessage(message: response.message));

    //Case success
    if (response.success) {
      return true;
    }
    return false;
  }

  ///Save User
  static Future<bool> saveUser({required UserModel user}) async {
    return await UtilPreferences.setString(
      Preferences.user,
      jsonEncode(user.toJson()),
    );
  }

  ///Load User
  static Future<UserModel?> loadUser() async {
    final result = UtilPreferences.getString(Preferences.user);
    if (result != null) {
      return UserModel.fromJson(jsonDecode(result));
    }
    return null;
  }

  ///Fetch User
  static Future<UserModel?> fetchUser() async {
    final response = await apiHandler.requestUser();
    if (response.success) {
      return UserModel.fromJson(response.data);
    }
    AppBloc.messageBloc.add(OnMessage(message: response.message));
    return null;
  }

  ///Delete User
  static Future<bool> deleteUser() async {
    return await UtilPreferences.remove(Preferences.user);
  }
}
