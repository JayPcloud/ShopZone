import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme textTheme = const TextTheme(

    bodyLarge:
        TextStyle(color: TColors.primaryColor, fontWeight: FontWeight.bold),

    bodyMedium: TextStyle(
      color: TColors.secondaryColor,
    ),

    bodySmall: TextStyle(color: TColors.primaryColor, fontSize: 10),

    displayLarge: TextStyle(
        color: TColors.secondaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 15),

    displayMedium: TextStyle(
        color: TColors.secondaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 14),

    titleSmall: TextStyle(
        color: Colors.black45,
        fontWeight: FontWeight.w400,
        fontSize: 12),
    titleMedium: TextStyle(
        color: TColors.secondaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 13),

    titleLarge: TextStyle(
        color: TColors.secondaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 15),

    headlineSmall: TextStyle(
        color: TColors.secondaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 12),

  );
}
