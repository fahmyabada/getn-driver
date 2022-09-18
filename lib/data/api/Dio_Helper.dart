import 'dart:io';

import 'package:dio/dio.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    print('serverUrl*************** ${getIt<SharedPreferences>().getString('serverUrl')}');
    dio = Dio(BaseOptions(
      baseUrl: getIt<SharedPreferences>().getString('serverUrl') ?? '',
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return await dio.get(url, queryParameters: query,
        onReceiveProgress: (received, total) {
      // progress.add(((received / total) * 100).toStringAsFixed(0));
    });
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    String? data,
  }) async {
    return await dio.post(url, queryParameters: query, data: data,
        onReceiveProgress: (received, total) {
      // progress.add(((received / total) * 100).toStringAsFixed(0));
      // progressType.add(url);
    });
  }

  static Future<Response> postData2({
    required String url,
    FormData? data,
  }) async {
    return await dio.post(url, data: data,
        onReceiveProgress: (received, total) {
          // progress.add(((received / total) * 100).toStringAsFixed(0));
          // progressType.add(url);
        });
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
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
