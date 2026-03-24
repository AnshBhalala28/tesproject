import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCustomSuccessSnackbar(BuildContext context,
    {required String title, required String message}) {
  DelightToastBar(
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
    snackbarDuration: const Duration(seconds: 3),
    builder: (context) => ToastCard(
      color: Colors.green,
      shadowColor: Colors.black26,
      leading: const Icon(Icons.check_circle_rounded, color: Colors.white),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            message,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    ),
  ).show(context);
}

void showCustomErrorSnackbar(BuildContext context,
    {required String title, required String message}) {
  DelightToastBar(
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
    snackbarDuration: const Duration(seconds: 2),
    builder: (context) => ToastCard(
      color: Colors.red,
      shadowColor: Colors.black26,
      leading: const Icon(Icons.error_outline_rounded, color: Colors.white),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            message,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    ),
  ).show(context);
}
