import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/styles/color_scheme.dart';
import 'package:sage/app/styles/typography.dart';

abstract class ThemeFactory {
  static TypographyExtension createTypography(AppColorScheme colors) =>
      TypographyExtension.from(colors);

  static AppColorScheme get colorSchemeLight => AppColorScheme.light();

  static ThemeData lightThemeData() => ThemeData.light().copyWith(
        extensions: [colorSchemeLight, createTypography(colorSchemeLight)],
        scaffoldBackgroundColor: colorSchemeLight.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: colorSchemeDark.white,
          contentTextStyle: TextStyle(color: colorSchemeLight.textLightGreen),
          actionTextColor: colorSchemeLight.textLightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.smallRadius),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
            borderSide: BorderSide(color: colorSchemeLight.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
            borderSide: BorderSide(color: colorSchemeLight.border),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
            borderSide: BorderSide(color: colorSchemeLight.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
            borderSide: BorderSide(color: colorSchemeLight.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
            borderSide: BorderSide(color: colorSchemeLight.mainGreenLight),
          ),
          hintStyle: TextStyle(color: colorSchemeLight.hint),
          errorStyle: TextStyle(color: colorSchemeLight.red),
          iconColor: colorSchemeLight.icon,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: colorSchemeLight.white,
          dragHandleColor:
              colorSchemeLight.textDarkGreen.withValues(alpha: 0.20),
          dragHandleSize: Size(130.w, 8.h),
          showDragHandle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadiuses.extraLargeRadius),
            ),
          ),
        ),
        chipTheme: ChipThemeData(),
        checkboxTheme: CheckboxThemeData(),
      );

  static AppColorScheme get colorSchemeDark => AppColorScheme.dark();

  static ThemeData darkThemeData() => ThemeData.dark().copyWith(
        extensions: [colorSchemeDark, createTypography(colorSchemeDark)],
        scaffoldBackgroundColor: colorSchemeLight.white,
        appBarTheme: AppBarTheme(
          backgroundColor: colorSchemeLight.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: colorSchemeDark.white,
          contentTextStyle: TextStyle(color: colorSchemeLight.textLightGreen),
          actionTextColor: colorSchemeLight.textLightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.smallRadius),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
            borderSide: BorderSide(color: colorSchemeLight.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
            borderSide: BorderSide(color: colorSchemeLight.mainGreenLight),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
            borderSide: BorderSide(color: colorSchemeLight.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
            borderSide: BorderSide(color: colorSchemeLight.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
            borderSide: BorderSide(color: colorSchemeLight.mainGreenLight),
          ),
          hintStyle: TextStyle(color: colorSchemeLight.hint),
          errorStyle: TextStyle(color: colorSchemeLight.red),
          iconColor: colorSchemeLight.icon,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: colorSchemeLight.white,
          dragHandleColor:
              colorSchemeLight.textDarkGreen.withValues(alpha: 0.20),
          dragHandleSize: Size(130.w, 8.h),
          showDragHandle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadiuses.largeRadius),
            ),
          ),
        ),
        chipTheme: ChipThemeData(),
        checkboxTheme: CheckboxThemeData(),
      );
}
