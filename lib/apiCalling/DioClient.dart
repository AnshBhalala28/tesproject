import 'package:dio/dio.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  /// GET
  static Future<Response> get(String url) async {
    return await dio.get(url);
  }

  /// POST
  static Future<Response> post(
      String url, {
        dynamic data,
      }) async {
    return await dio.post(
      url,
      data: data,
    );
  }

  /// PUT (Update)
  static Future<Response> put(
      String url, {
        dynamic data,
      }) async {
    return await dio.put(
      url,
      data: data,
    );
  }

  /// DELETE
  static Future<Response> delete(String url) async {
    return await dio.delete(url);
  }
}