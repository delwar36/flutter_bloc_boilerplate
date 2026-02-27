import 'dart:convert';
import 'package:dio/dio.dart';
import '../blocs/bloc.dart';
import '../configs/config.dart';
import '../models/model.dart';
import '../utils/logger.dart';

class HTTPManager {
  late final Dio dio;

  HTTPManager._internal() {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: Application.domain,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.json,
    );

    dio = Dio(baseOptions);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          Map<String, dynamic> headers = {
            "Device-Id": Application.device?.uuid ?? '',
            "Device-Name": utf8.encode(Application.device?.name ?? ''),
            "Device-Model": Application.device?.model ?? '',
            "Device-Version": Application.device?.version ?? '',
            "Push-Token": Application.device?.token ?? '',
            "Type": Application.device?.type ?? '',
            "Lang": AppBloc.languageCubit.state.languageCode,
          };
          options.headers.addAll(headers);

          UserModel? user = AppBloc.userCubit.state;
          if (user != null) {
            options.headers["Authorization"] = "Bearer ${user.token}";
          } else {
            options.headers.remove("Authorization");
          }

          UtilLogger.log("REQUEST[${options.method}]", options.uri);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          UtilLogger.log(
            "RESPONSE[${response.statusCode}]",
            response.requestOptions.uri,
          );
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          UtilLogger.log("ERROR[${error.type}]", error.message);

          // Example Retry logic for connection issues (can be expanded)
          if (_shouldRetry(error)) {
            try {
              final response = await _retry(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }

          // Centralized Error Handling
          final errorMessage = _handleDioError(error);
          return handler.resolve(
            Response(
              requestOptions: error.requestOptions,
              data: errorMessage,
              statusCode: error.response?.statusCode,
            ),
          );
        },
      ),
    );
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }

  Future<Response> _retry(RequestOptions requestOptions) {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Map<String, dynamic> _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.badResponse:
        if (error.response?.data is Map<String, dynamic>) {
          return error.response!.data;
        }
        return {"success": false, "message": "json_format_error"};
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionTimeout:
        return {"success": false, "message": "request_time_out"};
      default:
        return {"success": false, "message": "connect_to_server_fail"};
    }
  }

  ///Post method
  Future<dynamic> post({
    required String url,
    Map<String, dynamic>? data,
    FormData? formData,
    Options? options,
    Function(num)? progress,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: data ?? formData,
        options: options,
        onSendProgress: (sent, total) {
          if (progress != null && total > 0) {
            progress((sent / total) / 0.01);
          }
        },
      );
      return response.data;
    } catch (e) {
      return {"success": false, "message": "unexpected_error"};
    }
  }

  ///Get method
  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? params,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: params,
        options: options,
      );
      return response.data;
    } catch (e) {
      return {"success": false, "message": "unexpected_error"};
    }
  }

  factory HTTPManager() {
    return httpManager;
  }
}

final HTTPManager httpManager = HTTPManager._internal();
