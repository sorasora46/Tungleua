import 'package:flutter/material.dart';

class SnackBarVariant {
  static String error = 'error';
  static String success = 'success';
  static String info = 'info';
}

/// variant: 'error' | 'success'
void showCustomSnackBar(BuildContext context, String message, String variant) {
  Color color = Colors.white;
  if (variant == SnackBarVariant.error) {
    color = Colors.red;
  }
  if (variant == SnackBarVariant.success) {
    color = Colors.green;
  }
  if (variant == SnackBarVariant.info) {
    color = Colors.lightBlue;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: color,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        content: Text(message, style: const TextStyle(fontSize: 16))),
  );
}
