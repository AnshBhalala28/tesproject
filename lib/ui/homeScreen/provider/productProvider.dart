import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:testproject/util/DioClient.dart';
import 'package:testproject/util/apiConstants.dart';


class ProductProvider extends ChangeNotifier{

  Future<Response> DioGetProduct() async {
    try {
      final Dio dio = await DioHelper.getDio();

      String url = "${ApiConstants.products}";

      log("BOOKING LIST URL $url");

      final response = await dio.get(
        url,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          validateStatus: (status) {
            return status != null && (status == 200 || status == 422);
          },
        ),
      );

      log("STATUS ${response.statusCode}");
      log("RESPONSE ${response.data}");

      return response;

    } catch (e) {
      log("BOOKING LIST ERROR $e");
      rethrow;
    }
  }

}