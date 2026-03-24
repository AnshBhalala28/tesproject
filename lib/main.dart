import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sizer/sizer.dart';
import 'package:testproject/service/notificationService.dart';
import 'package:testproject/ui/homeScreen/view/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> getToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  log("FCM TOKEN ==> $token");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Permission (IMPORTANT for iOS)
  await FirebaseMessaging.instance.requestPermission();

  // ✅ Notification init
  await NotificationService.init();

  // ✅ Foreground notification
  FirebaseMessaging.onMessage.listen((message) {
    NotificationService.showNotification(
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
    );
  });

  await Hive.initFlutter();
  await Hive.openBox('cart');
  await Hive.openBox('orders');

  runApp(
    Sizer(
      builder: (context, orientation, deviceType) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}