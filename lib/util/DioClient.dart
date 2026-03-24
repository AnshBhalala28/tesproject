import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:testproject/util/apiConstants.dart';


class DioHelper {
    static Dio? _dio;

    static Future<Dio> getDio() async {
        if (_dio != null) return _dio!;

        try {
            log("Dio Init");

            final certData =
            await rootBundle.load('assets/certificate/fakestore.pem');

            final SecurityContext securityContext =
            SecurityContext(withTrustedRoots: true);

            securityContext.setTrustedCertificatesBytes(
                certData.buffer.asUint8List());

            _dio = Dio(
                BaseOptions(
                    baseUrl: ApiConstants.baseUrl,
                    connectTimeout: const Duration(seconds: 60),
                    receiveTimeout: const Duration(seconds: 60),
                    responseType: ResponseType.json,
                ),
            );

            _dio!.httpClientAdapter = IOHttpClientAdapter(
                createHttpClient: () {
                    final client = HttpClient(context: securityContext);

                    if (kDebugMode) {
                        client.badCertificateCallback =
                            (X509Certificate cert, String host, int port) {
                            log("Debug SSL bypass for $host");
                            return true;
                        };
                    }

                    return client;
                },
            );
        } catch (e, s) {
            log("Dio init failed", error: e, stackTrace: s);
            rethrow;
        }

        return _dio!;
    }
}