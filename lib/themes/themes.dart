import 'package:api_practice/themes/custom_themes/textTheme.dart';
import 'package:api_practice/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TTheme {

  TTheme._();

  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: TColors.primaryColor,
    primaryColor: TColors.primaryColor,
    textTheme: TTextTheme.textTheme,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      outline: TColors.secondaryColor,

    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: TColors.secondaryColor, fontSize: 16, fontWeight: FontWeight.w700),
      actionsIconTheme: IconThemeData(
        color: TColors.tertiaryColor
      ),
    ),
    iconTheme: const IconThemeData(
        color: TColors.tertiaryColor
    ),
  );
}