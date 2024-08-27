import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';

class ThemeDataFactory {
  static ThemeData toThemeData(AppTheme theme) {
    return ThemeData(
        useMaterial3: false,
        brightness: theme.brightness,
        fontFamily: theme.typography.fontFamily,
        colorScheme: ColorScheme.fromSeed(
            seedColor: theme.primary,
            brightness: theme.brightness,
            primary: theme.primary,
            onPrimary: theme.primaryText,
            secondary: theme.secondary,
            onSecondary: theme.secondaryText,
            background: theme.primaryBackground,
            onBackground: theme.primaryText,
            error: theme.error,
            onError: theme.primaryBtnText,
            surface: theme.secondaryBackground,
            onSurface: theme.primaryText),
        bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: theme.secondaryBackground),
        appBarTheme: AppBarTheme(
          backgroundColor: theme.primaryBackground,
          iconTheme: IconThemeData(
            color: theme.primaryText,
          ),
          titleTextStyle: TextStyle(color: theme.primaryText, fontSize: 21.sp),
        ),
        dialogTheme: DialogTheme(backgroundColor: theme.secondaryBackground),
        primaryColor: theme.primary,
        iconTheme: IconThemeData(
          color: theme.primaryText,
        ),
        bannerTheme: const MaterialBannerThemeData(),
        chipTheme: const ChipThemeData(),
        snackBarTheme: SnackBarThemeData(
            backgroundColor: theme.secondaryBackground),
        scaffoldBackgroundColor: theme.primaryBackground,
        radioTheme: RadioThemeData(
          fillColor: MaterialStatePropertyAll(theme.primary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              theme.primary,
            ),
            foregroundColor: MaterialStatePropertyAll(
              theme.primaryBtnText,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                theme.primary,
              ),
              // maximumSize: MaterialStateProperty.all(const Size(200, 60)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(theme.radius),
                      side: BorderSide(
                        color: theme.lineColor,
                      )))),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          refreshBackgroundColor: theme.secondaryBackground,
          color: theme.primary,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: theme.primary,
          selectionHandleColor: theme.primary,
          selectionColor: Colors.black12, //TODO ASSIGN
        ),
        // inputDecorationTheme:  InputDecorationTheme(
        //   border: InputBorder.none,
        //   hintStyle: TextStyle(color: Colors.black26, fontFamily: 'Poppins'),
        //   fillColor: Colors.white,
        //   focusedBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(5.r),
        //         borderSide:
        //             BorderSide(color: AppColors.bole.withOpacity(0.25)),
        //       ),
        //   enabledBorder: InputBorder.none,
        //   errorBorder: InputBorder.none,
        //   disabledBorder: InputBorder.none,
        // ),
        indicatorColor: theme.primary,
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStatePropertyAll(
            theme.primary,
          ),
          trackColor: const MaterialStatePropertyAll(
            Color(0xFF06309A), //TODO ASSIGN
          ),
        ),
        dividerTheme: const DividerThemeData(color: Colors.black12),
        textTheme: TextTheme(
          bodyLarge: theme.typography.bodyLarge,
          bodyMedium: theme.typography.bodyMedium,
          bodySmall: theme.typography.bodySmall,
          displayLarge: theme.typography.displayLarge,
          displayMedium: theme.typography.displayMedium,
          displaySmall: theme.typography.displaySmall,
          headlineLarge: theme.typography.headlineLarge,
          headlineMedium: theme.typography.headlineMedium,
          headlineSmall: theme.typography.headlineSmall,
          labelLarge: theme.typography.labelLarge,
          labelMedium: theme.typography.labelMedium,
          labelSmall: theme.typography.labelSmall,
          titleLarge: theme.typography.titleLarge,
          titleMedium: theme.typography.titleMedium,
          titleSmall: theme.typography.titleSmall,
        ));
  }
}