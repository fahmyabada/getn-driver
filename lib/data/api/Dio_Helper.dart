import 'dart:io';

import 'package:dio/dio.dart';

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
    String? token,
  }) async {
    token != null
        ? dio.options.headers = {
            'Authorization': 'bearerAuth $token',
          }
        : null;
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    String? data,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization': 'bearerAuth $token',
    };
    return await dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> postData2({
    required String url,
    Map<String, dynamic>? query,
    FormData? data,
    String? header,
    String? apiKey,
    String? firebaseToken,
  }) async {
    dio.options.headers = {
      'Content-Type': header,
      'api_key': apiKey,
      'firebase_token': firebaseToken
    };
    return await dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> postData3({
    required String url,
    Map<String, dynamic>? query,
    FormData? data,
    String? token,
  }) async {
    dio.options.headers = {
      // 'Content-Type': 'multipart/form-data',
      'Authorization': 'bearerAuth $token',
    };
    return await dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    FormData? data,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization': 'bearerAuth $token',
    };
    return await dio.put(url, queryParameters: query, data: data);
  }

  static Future<Response> putData2({
    required String url,
    FormData? data,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization': 'bearerAuth $token',
    };
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
