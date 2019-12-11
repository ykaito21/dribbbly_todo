import 'package:flutter/material.dart';

class ViewStateWidget {
  static Widget loadingViewState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget emptyViewState(String text) {
    return Center(
      child: Text(text),
    );
  }

  static Widget errorViewState(String text) {
    return Center(
      child: Text(text),
    );
  }
}
