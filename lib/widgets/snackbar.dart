import 'package:flutter/material.dart';
import 'package:lively_studio/app_color.dart';

import 'custom_snackbar.dart';

class GeneralSnackBar {
  final BuildContext _context;

  GeneralSnackBar(this._context);

  void showErrorSnackBar(String message) {
    final snackBar = CustomSnackBar(
        message: message, iconData: Icons.error, color: errorPrimary);
    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
  }

  void showWarningSnackBar(String message) {
    final snackBar = CustomSnackBar(
        message: message, iconData: Icons.warning_amber_rounded, color: warningPrimary);
    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
  }

  void showSuccessSnackBar(String message) {
    final snackBar = CustomSnackBar(
        message: message, iconData: Icons.check_circle, color: darkGreen);
    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
  }

  void hideSnackBar() {
    ScaffoldMessenger.of(_context).hideCurrentSnackBar();
  }
}
