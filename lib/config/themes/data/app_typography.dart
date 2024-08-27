
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';

abstract class AppTypography {
  String get fontFamily;
  TextStyle get displayLarge;
  TextStyle get displayMedium;
  TextStyle get displaySmall;
  TextStyle get headlineLarge;
  TextStyle get headlineMedium;
  TextStyle get headlineSmall;
  TextStyle get titleLarge;
  TextStyle get titleMedium;
  TextStyle get titleSmall;
  TextStyle get labelLarge;
  TextStyle get labelMedium;
  TextStyle get labelSmall;
  TextStyle get bodyLarge;
  TextStyle get bodyMedium;
  TextStyle get bodySmall;
}

class ThemeTypography extends AppTypography {
  ThemeTypography(this.theme);

  final AppTheme theme;
  
  @override
  String get fontFamily => "plusJakartaSans";
  @override
  TextStyle get displayLarge => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 64.sp,
  );
  @override
  TextStyle get displayMedium => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 44.sp,
  );
  @override
  TextStyle get displaySmall => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 36.sp,
  );
  @override
  TextStyle get headlineLarge => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 32.sp,
  );
  @override
  TextStyle get headlineMedium => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 24.sp,
  );
  @override
  TextStyle get headlineSmall => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w500,
    fontSize: 24.sp,
  );
  @override
  TextStyle get titleLarge => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w500,
    fontSize: 22.sp,
  );
  @override
  TextStyle get titleMedium => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 18.sp,
  );
  @override
  TextStyle get titleSmall => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
  );
  @override
  TextStyle get labelLarge => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 16.sp,
  );
  @override
  TextStyle get labelMedium => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 14.sp,
  );
  @override
  TextStyle get labelSmall => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 12.sp,
  );
  @override
  TextStyle get bodyLarge => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 16.sp,
  );
  @override
  TextStyle get bodyMedium => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 14.sp,
  );
  @override
  TextStyle get bodySmall => TextStyle(
    fontFamily: fontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 12.sp,
  );
}