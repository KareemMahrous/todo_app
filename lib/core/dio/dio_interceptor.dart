import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:task_manager_app/domain/repo/auth_repo.dart';

import '../../dependency_injection.dart';
import '../constants/shared_keys.dart';

class DioInterceptor implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("===================");
    log("Error");
    log("url:=> ${err.requestOptions.path}");
    log("statusCode:=> ${err.response?.statusCode}");
    log("body:=> ${err.response?.data}");
    log("===================");
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = preferences.getString(SharedKeys.accessToken);
    options.headers["Authorization"] = "Bearer $token";
    log("=======================================");
    log("Request");
    log("url:=> ${options.path}");
    log("content:=> ${options.contentType}");
    log("headers:=> hasToken:${token != null}");
    log("body:=> ${options.data != null ? options.data! : "Data is null"}");
    log("=======================================");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401) {
      getIt<AuthRepo>().refresh();
    }

    log("=======================================");
    log("Response:");
    log("url:=> ${response.requestOptions.path}");
    log("statusCode:=> ${response.statusCode}");
    log("body:=> hasData: ${response.data != null}");
    log("=======================================");
    handler.next(response);
  }
}
