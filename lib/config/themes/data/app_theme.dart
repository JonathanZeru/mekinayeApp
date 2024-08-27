import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mekinaye/config/themes/data/app_typography.dart';
import 'package:mekinaye/config/themes/data/theme_data_factory.dart';

abstract class AppTheme {
  static AppTheme of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? DarkModeTheme()
        : LightModeTheme();
  }

  late Brightness brightness;
  late Color primary;
  late Color secondary;
  late Color tertiary;
  late Color alternate;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color accent1;
  late Color accent2;
  late Color accent3;
  late Color accent4;
  late Color accent5;
  late Color success;
  late Color warning;
  late Color error;
  late Color info;
  late double radius;

  late Color primaryBtnText;
  late Color lineColor;
  late Color cardBackground;
  late Color cardText;
  late List<Color> cardBackgroundColors;
  late Color skeletonBaseHighlightColor;
  late Color unclickedColor;

  AppTypography get typography => ThemeTypography(this);

  ThemeData get themeData => ThemeDataFactory.toThemeData(this);
}

class LightModeTheme extends AppTheme {
  @override
  Brightness get brightness => Brightness.light;
  @override
  Color get primary => const Color(0xFFFF0800);
  @override
  Color get secondary => const Color(0xFF39D2C0); //Todo assign
  @override
  Color get tertiary => const Color(0xFFEE8B60); //Todo assign
  @override
  Color get alternate => const Color(0xFFE0E3E7); //Todo assign
  @override
  Color get primaryText => const Color(0xFF2E2E2E);
  @override
  Color get secondaryText => const Color(0xFFFF0800);
  @override
  Color get primaryBackground => const Color(0xFFFBFBFB);
  @override
  Color get secondaryBackground => const Color(0xFFFFFFFF);
  @override
  Color get accent1 => const Color(0xFFF5F8FF);
  @override
  Color get accent2 => const Color(0xFF808080);
  @override
  Color get accent3 => const Color(0xFFF4F2EE); //Todo assign
  @override
  Color get accent4 => const Color(0xCCFFFFFF); //Todo assign
  @override
  Color get accent5 => const Color(0xFF808080); //Todo assign
  @override
  Color get success => const Color(0xFF00970F);
  @override
  Color get warning => const Color(0xFFF9CF58);
  @override
  Color get error => const Color(0xFFFF0800);
  @override
  Color get info => const Color(0xFFFFFFFF);
  @override
  double get radius => 8.r;

  @override
  Color get primaryBtnText => const Color(0xFFFFFFFF);
  @override
  Color get lineColor => const Color(0xFFB7B7B7);
  @override
  Color get cardBackground => const Color(0xFFF2F2F2);
  @override
  Color get cardText => const Color(0xFF2E2E2E);
  @override
  List<Color> get cardBackgroundColors => [
        const Color(0xFFDEB887), // Burly wood
        const Color(0xFFD2B48C), // Tan
        const Color(0xFFBC8F8F), // Rosy brown
        const Color(0xFFCD853F), // Peru
        const Color(0xFF8B4513), // Saddle brown
        const Color(0xFFA0522D), // Sienna
        const Color(0xFFBC8F8F), // Rosy brown
        const Color(0xFFDEB887), // Burly wood
        const Color(0xFFCD853F), // Peru
        const Color(0xFF8B4513), // Saddle brown
      ];

  @override
  Color get skeletonBaseHighlightColor =>
      const Color.fromARGB(170, 199, 199, 199);
  @override
  Color get unclickedColor => accent2;
}

class DarkModeTheme extends AppTheme {
  //Todo assign all
  @override
  Brightness get brightness => Brightness.dark;
  @override
  Color get primary => const Color(0xFFFF0800);
  @override
  Color get secondary => const Color(0xFF39D2C0);
  @override
  Color get tertiary => const Color(0xFFEE8B60);
  @override
  Color get alternate => const Color.fromARGB(255, 74, 81, 88);
  @override
  Color get primaryText => const Color(0xFFFFFFFF);
  @override
  Color get secondaryText => const Color(0xFF95A1AC);
  @override
  Color get primaryBackground => const Color(0xFF1D2428);
  @override
  Color get secondaryBackground => const Color(0xFF14181B);
  @override
  Color get accent1 => const Color(0xFFF5F8FF);
  @override
  Color get accent2 => const Color(0x4D39D2C0);
  @override
  Color get accent3 => const Color(0xFFFF0800);
  @override
  Color get accent4 => const Color(0xB2262D34);
  @override
  Color get accent5 => const Color(0xFFFFFFFF); //Todo assign
  @override
  Color get success => const Color(0xFF249689);
  @override
  Color get warning => const Color(0xFFF9CF58);
  @override
  Color get error => const Color(0xFFFF0800);
  @override
  Color get info => const Color(0xFFFFFFFF);
  @override
  double get radius => 8.r;

  @override
  Color get primaryBtnText => const Color(0xFFFFFFFF);
  @override
  Color get lineColor => const Color(0xFF22282F);
  @override
  Color get cardBackground => const Color.fromARGB(255, 105, 62, 51);
  @override
  Color get cardText => const Color(0xFFFFFFFF);
  @override
  List<Color> get cardBackgroundColors => [
        const Color(0xFFD2B48C), // Tan
        const Color(0xFFBC8F8F), // Rosy brown
        const Color(0xFFCD853F), // Peru
        const Color(0xFF8B4513), // Saddle brown
        const Color(0xFFA0522D), // Sienna
        const Color(0xFFDEB887), // Burly wood
        const Color(0xFFBC8F8F), // Rosy brown
        const Color(0xFFD2B48C), // Tan
        const Color(0xFFCD853F), // Peru
        const Color(0xFF8B4513), // Saddle brown
      ];
  @override
  Color get skeletonBaseHighlightColor => tertiary.withOpacity(0.5);
  @override
  Color get unclickedColor => const Color(0xFF808080);
}
