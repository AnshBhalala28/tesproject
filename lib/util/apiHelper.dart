import 'package:dio/dio.dart';

class ApiHelper {
  /// Common API Call Handler
  static Future<T?> safeApiCall<T>({
    required Future<T> Function() apiCall,
  }) async {
    try {
      final response = await apiCall();
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      print("Unknown Error: $e");
      return null;
    }
  }

  /// Dio Error Handler
  static void _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        print("Connection Timeout");
        break;

      case DioExceptionType.sendTimeout:
        print("Send Timeout");
        break;

      case DioExceptionType.receiveTimeout:
        print("Receive Timeout");
        break;

      case DioExceptionType.badResponse:
        print("Server Error: ${e.response?.statusCode}");
        break;

      case DioExceptionType.cancel:
        print("Request Cancelled");
        break;

      case DioExceptionType.unknown:
        print("No Internet / Unknown Error");
        break;

      default:
        print("Something went wrong");
    }
  }
}