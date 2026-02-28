import '../configs/config.dart';
import '../models/model.dart';

class UserApi {
  static const String login = "";
  static const String authValidate = "";
  static const String user = "";
  static const String register = "";
  static const String forgotPassword = "";
  static const String changePassword = "";
  static const String changeProfile = "";

  ///Login api
  static Future<ResultApiModel> requestLogin(params) async {
    final result = await httpManager.post(url: login, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Validate token valid
  static Future<ResultApiModel> requestValidateToken() async {
    Map<String, dynamic> result = await httpManager.post(url: authValidate);
    result['success'] = result['code'] == 'jwt_auth_valid_token';
    result['message'] = result['code'] ?? result['message'];
    return ResultApiModel.fromJson(result);
  }

  ///Forgot password
  static Future<ResultApiModel> requestForgotPassword(params) async {
    Map<String, dynamic> result = await httpManager.post(
      url: forgotPassword,
      data: params,
    );
    result['message'] = result['code'] ?? result['msg'];
    return ResultApiModel.fromJson(result);
  }

  ///Register account
  static Future<ResultApiModel> requestRegister(params) async {
    final result = await httpManager.post(url: register, data: params);
    final convertResponse = {
      "success": result['code'] == 200,
      "message": result['message'],
      "data": result,
    };
    return ResultApiModel.fromJson(convertResponse);
  }

  ///Change Profile
  static Future<ResultApiModel> requestChangeProfile(params) async {
    final result = await httpManager.post(url: changeProfile, data: params);
    final convertResponse = {
      "success": result['code'] == null,
      "message": result['code'] ?? "update_info_success",
      "data": result,
    };
    return ResultApiModel.fromJson(convertResponse);
  }

  ///change password
  static Future<ResultApiModel> requestChangePassword(params) async {
    final result = await httpManager.post(url: changePassword, data: params);
    final convertResponse = {
      "success": result['code'] == null,
      "message": result['code'] ?? "change_password_success",
      "data": result,
    };
    return ResultApiModel.fromJson(convertResponse);
  }

  ///Get User
  static Future<ResultApiModel> requestUser() async {
    final result = await httpManager.get(url: user);
    return ResultApiModel.fromJson(result);
  }
}
