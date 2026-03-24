import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:testproject/ui/homeScreen/modal/productModel.dart';

Future<bool> checkInternet() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    print("🔌 Not connected to any network");
    return false;
  }

  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print("🌐 Connected to internet");
      return true;
    }
  } on SocketException catch (_) {
    print("🌐 Network connected but no internet access");
    return false;
  }

  return false;
}


GetDioModel? getDioModel;