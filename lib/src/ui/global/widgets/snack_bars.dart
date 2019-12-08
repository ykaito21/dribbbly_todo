import 'package:flutter/material.dart';

class SnackBars {
  static SnackBar baseSnackBar(
    BuildContext context,
    String snackBarText,
  ) {
    return SnackBar(
      // behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1000),
      backgroundColor: Theme.of(context).accentColor,
      content: Text(
        snackBarText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
