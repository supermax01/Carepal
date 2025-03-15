import 'package:flutter/material.dart';

class RedcapErrorHandler {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static String getErrorMessage(dynamic error) {
    if (error is Map<String, dynamic>) {
      return error['error'] ?? 'An unknown error occurred';
    }
    return error.toString();
  }
}
