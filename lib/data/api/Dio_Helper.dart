import 'dart:io';

import 'package:dio/dio.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://apis.getn.re-comparison.com/api/',
      receiveDataWhenStatusError: true, 
    ));
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    String? data,
  }) async {
    return await dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> postData2({
    required String url,
    FormData? data,
    String? header,
  }) async {
    dio.options.headers = {
      'Content-Type': header,
    };
    return await dio.post(url, data: data);
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic>? query,
    String? data,
  }) async {
    return await dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData2({
    required String url,
    FormData? data,
    String? header,
  }) async {
    getIt<SharedPreferences>().getString("token") != null
        ? dio.options.headers = {
      'Authorization': 'bearerAuth ${getIt<SharedPreferences>().getString("token")}',
    }
        : null;
    return await dio.put(
      url,
      data: data,
    );
  }

}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

String handleError(dynamic error) {
  String errorDescription = "";

  print("handleError:: error >> $error");

  if (error is DioError) {
    print("************************ DioError ************************");

    DioError dioError = error;
    print("dioError:: $dioError");
    if (dioError.response != null) {
      print("dioError:: response >> ${dioError.response}");
    }

    switch (dioError.type) {
      case DioErrorType.other:
        errorDescription =
        "Connection to API server failed due to internet connection";
        break;
      case DioErrorType.cancel:
        errorDescription = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        errorDescription = "Connection timeout with API server";
        break;
      case DioErrorType.receiveTimeout:
        errorDescription = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        errorDescription = "Error: ${dioError.response?.data["message"]}";
        break;
      case DioErrorType.sendTimeout:
        errorDescription = "Send timeout in connection with API server";
        break;
    }
  } else {
    errorDescription = "Unexpected error occured";
  }
  print("handleError:: errorDescription >> $errorDescription");
  return errorDescription;
}

