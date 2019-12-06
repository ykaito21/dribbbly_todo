import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../global/color_list.dart';

enum AppTheme {
  DribbblyLight,
  DribbblyDark,
}

final appThemes = {
  AppTheme.DribbblyLight: ThemeData().copyWith(
    primaryColor: ColorList.baseWhite,
    accentColor: ColorList.basePink,
    primaryColorDark: ColorList.baseGray,
    scaffoldBackgroundColor: ColorList.baseWhite,
    // cupertinoOverrideTheme: CupertinoThemeData(
    //   primaryColor: ColorsList.primaryPink,
    // ),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        title: TextStyle(
          color: ColorList.baseGray,
        ),
      ),
      iconTheme: IconThemeData(
        color: ColorList.baseGray,
      ),
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorList.basePink,
      foregroundColor: ColorList.baseWhite,
    ),
  ),
  AppTheme.DribbblyDark: ThemeData.dark().copyWith(
    primaryColor: ColorList.baseBlack,
    accentColor: ColorList.basePink,
    primaryColorDark: ColorList.baseGray,
    scaffoldBackgroundColor: ColorList.baseBlack,
    // cupertinoOverrideTheme: CupertinoThemeData(
    //   primaryColor: ColorList.basePink,
    // ),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        title: TextStyle(
          color: ColorList.baseGray,
        ),
      ),
      iconTheme: IconThemeData(
        color: ColorList.baseGray,
      ),
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorList.basePink,
      foregroundColor: ColorList.baseWhite,
    ),
  ),
};
