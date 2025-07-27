
import 'package:flutter/material.dart';
import 'package:wao_mobile/widgets/top_snack_bar.dart';

class TopSnackBarStyles {
  static void success(
      BuildContext context, {
        required String title,
        required String message,
        IconData icon = Icons.check_circle,
      }) {
    TopSnackBar.show(
      context,
      title: title,
      message: message,
      icon: icon,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      iconColor: Colors.white,
    );
  }

  static void error(
      BuildContext context, {
        required String title,
        required String message,
        IconData icon = Icons.error,
      }) {
    TopSnackBar.show(
      context,
      title: title,
      message: message,
      icon: icon,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      iconColor: Colors.white,
    );
  }

  static void warning(
      BuildContext context, {
        required String title,
        required String message,
        IconData icon = Icons.warning,
      }) {
    TopSnackBar.show(
      context,
      title: title,
      message: message,
      icon: icon,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      iconColor: Colors.white,
    );
  }

  static void info(
      BuildContext context, {
        required String title,
        required String message,
        IconData icon = Icons.info,
      }) {
    TopSnackBar.show(
      context,
      title: title,
      message: message,
      icon: icon,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      iconColor: Colors.white,
    );
  }
}
