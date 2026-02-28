// ignore_for_file: strict_top_level_inference

import 'dart:async';

import '../api/http_manager.dart';
import '../models/model.dart';
import '../utils/logger.dart';

class Api {
  ///URL API
  final String login = "/jwt-auth/v1/token";
  final String authValidate = "/jwt-auth/v1/token/validate";
  final String user = "/v1/auth/user";
  final String register = "/v1/auth/register";
  final String forgotPassword = "/v1/auth/reset_password";
  final String changePassword = "/wp/v2/users/me";
  final String changeProfile = "/wp/v2/users/me";
  final String setting = "/v1/setting/init";
  final String submitSetting = "/v1/place/form";
  final String home = "/v1/home/init";
  final String categories = "/v1/category/list";
  final String discovery = "/v1/category/list_discover";
  final String withLists = "/v1/wishlist/list";
  final String addWishList = "/v1/wishlist/save";
  final String removeWishList = "/v1/wishlist/remove";
  final String clearWithList = "/v1/wishlist/reset";
  final String list = "/v1/place/list";
  final String deleteProduct = "/v1/place/delete";
  final String authorList = "/v1/author/listing";
  final String authorReview = "/v1/author/comments";
  final String tags = "/v1/place/terms";
  final String comments = "/v1/comments";
  final String saveComment = "/wp/v2/comments";
  final String product = "/v1/place/view";
  final String saveProduct = "/v1/place/save";
  final String locations = "/v1/location/list";
  final String uploadImage = "/wp/v2/media";
  final String logSystem = "/v1/auth/log_system";

  ///Log System
  Future<ResultApiModel> requestLogSystem(params) async {
    final result = await httpManager.post(url: logSystem, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Login api
  Future<ResultApiModel> requestLogin(params) async {
    final result = await httpManager.post(url: login, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Validate token valid
  Future<ResultApiModel> requestValidateToken() async {
    Map<String, dynamic> result = await httpManager.post(url: authValidate);
    result['success'] = result['code'] == 'jwt_auth_valid_token';
    result['message'] = result['code'] ?? result['message'];
    return ResultApiModel.fromJson(result);
  }

  ///Forgot password
  Future<ResultApiModel> requestForgotPassword(params) async {
    Map<String, dynamic> result = await httpManager.post(
      url: forgotPassword,
      data: params,
    );
    result['message'] = result['code'] ?? result['msg'];
    return ResultApiModel.fromJson(result);
  }

  ///Register account
  Future<ResultApiModel> requestRegister(params) async {
    final result = await httpManager.post(url: register, data: params);
    final convertResponse = {
      "success": result['code'] == 200,
      "message": result['message'],
      "data": result,
    };
    return ResultApiModel.fromJson(convertResponse);
  }

  ///Change Profile
  Future<ResultApiModel> requestChangeProfile(params) async {
    final result = await httpManager.post(url: changeProfile, data: params);
    final convertResponse = {
      "success": result['code'] == null,
      "message": result['code'] ?? "update_info_success",
      "data": result,
    };
    return ResultApiModel.fromJson(convertResponse);
  }

  ///change password
  Future<ResultApiModel> requestChangePassword(params) async {
    final result = await httpManager.post(url: changePassword, data: params);
    final convertResponse = {
      "success": result['code'] == null,
      "message": result['code'] ?? "change_password_success",
      "data": result,
    };
    return ResultApiModel.fromJson(convertResponse);
  }

  ///Get User
  Future<ResultApiModel> requestUser() async {
    final result = await httpManager.get(url: user);
    return ResultApiModel.fromJson(result);
  }

  ///Get Setting
  Future<ResultApiModel> requestSetting() async {
    final result = await httpManager.get(url: setting);
    return ResultApiModel.fromJson(result);
  }

  ///Get Submit Setting
  Future<ResultApiModel> requestSubmitSetting(params) async {
    final result = await httpManager.get(url: submitSetting, params: params);
    final convertResponse = {
      "success": result['countries'] != null,
      "data": result,
    };
    return ResultApiModel.fromJson(convertResponse);
  }

  ///Get Area
  Future<ResultApiModel> requestLocation(params) async {
    final result = await httpManager.get(url: locations, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Get Category
  Future<ResultApiModel> requestCategory() async {
    final result = await httpManager.get(url: categories);
    return ResultApiModel.fromJson(result);
  }

  ///Get Discovery
  Future<ResultApiModel> requestDiscovery() async {
    final result = await httpManager.get(url: discovery);
    return ResultApiModel.fromJson(result);
  }

  ///Get Home
  Future<ResultApiModel> requestHome() async {
    final result = await httpManager.get(url: home);
    return ResultApiModel.fromJson(result);
  }

  ///Get ProductDetail
  Future<ResultApiModel> requestProduct(params) async {
    final result = await httpManager.get(url: product, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Get Wish List
  Future<ResultApiModel> requestWishList(params) async {
    final result = await httpManager.get(url: withLists, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Save Wish List
  Future<ResultApiModel> requestAddWishList(params) async {
    final result = await httpManager.post(url: addWishList, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Save Product
  Future<ResultApiModel> requestSaveProduct(params) async {
    final result = await httpManager.post(url: saveProduct, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Remove Wish List
  Future<ResultApiModel> requestRemoveWishList(params) async {
    final result = await httpManager.post(url: removeWishList, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Clear Wish List
  Future<ResultApiModel> requestClearWishList() async {
    final result = await httpManager.post(url: clearWithList);
    return ResultApiModel.fromJson(result);
  }

  ///Get Product List
  Future<ResultApiModel> requestList(params) async {
    final result = await httpManager.get(url: list, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Get Tags List
  Future<ResultApiModel> requestTags(params) async {
    final result = await httpManager.get(url: tags, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Clear Wish List
  Future<ResultApiModel> requestDeleteProduct(params) async {
    final result = await httpManager.post(url: deleteProduct, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Get Author Product List
  Future<ResultApiModel> requestAuthorList(params) async {
    final result = await httpManager.get(url: authorList, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Get Author Review List
  Future<ResultApiModel> requestAuthorReview(params) async {
    final result = await httpManager.get(url: authorReview, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Get Review
  Future<ResultApiModel> requestReview(params) async {
    final result = await httpManager.get(url: comments, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Save Review
  Future<ResultApiModel> requestSaveReview(params) async {
    final result = await httpManager.post(url: saveComment, data: params);
    final convertResponse = {
      "success": result['code'] == null,
      "message": result['message'] ?? "save_data_success",
      "data": result,
    };
    return ResultApiModel.fromJson(convertResponse);
  }

  ///Upload image
  Future<ResultApiModel> requestUploadImage(formData, progress) async {
    var result = await httpManager.post(
      url: uploadImage,
      formData: formData,
      progress: progress,
    );

    final convertResponse = {"success": result['id'] != null, "data": result};
    return ResultApiModel.fromJson(convertResponse);
  }

  ///Singleton factory
  static final Api _instance = Api._internal();

  factory Api() {
    return _instance;
  }

  Api._internal() {
    UtilLogger.onRemoteLog = (tag, message, stackTrace, device) async {
      await requestLogSystem({
        "tag": tag,
        "message": message,
        "stackTrace": stackTrace,
        "device": device,
      });
    };
  }
}

final Api apiHandler = Api();
