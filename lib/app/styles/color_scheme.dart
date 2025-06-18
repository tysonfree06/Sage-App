import 'package:flutter/material.dart';

class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.white,
    required this.greenBg,
    required this.mainGreenLight,
    required this.mainGreenDark,
    required this.border,
    required this.textDarkGreen,
    required this.textLightGreen,
    required this.subtext,
    required this.icon,
    required this.red,
    required this.chipBg,
    required this.yellow,
    required this.redBg,
    required this.hint,
    required this.navbarBg,
  });

  factory AppColorScheme.light() => const AppColorScheme(
        white: Color(0xFFF0F4F4),
        greenBg: Color(0xFF2F6164),
        mainGreenLight: Color(0xFF69B0AC),
        mainGreenDark: Color(0xFF2F6164),
        border: Color(0x1A172A2B), // 10% opacity
        textDarkGreen: Color(0xFF172A2B),
        textLightGreen: Color(0xFF2F6164),
        subtext: Color(0x99172A2B), // 60% opacity
        icon: Color(0xFF2F6164),
        red: Color(0xFFDE4A4A),
        chipBg: Color(0xFFE0E7E8),
        yellow: Color(0xFFF3E5AB),
        redBg: Color(0x1ADE4A4A), // 10% opacity
        hint: Color(0x99172A2B), // 60% opacity
        navbarBg: Color(0x0D172A2B), // 10% opacity
      );

  factory AppColorScheme.dark() => const AppColorScheme(
        white: Color(0xFFFFFFFF),
        greenBg: Color(0xFF2F6164),
        mainGreenLight: Color(0xFF69B0AC),
        mainGreenDark: Color(0xFF2F6164),
        border: Color(0x1A172A2B),
        textDarkGreen: Color(0xFF172A2B),
        textLightGreen: Color(0xFF2F6164),
        subtext: Color(0x99172A2B),
        icon: Color(0xFF2F6164),
        red: Color(0xFFDE4A4A),
        chipBg: Color(0xFFE0E7E8),
        yellow: Color(0xFFF3E5AB),
        redBg: Color(0x1ADE4A4A),
        hint: Color(0x99172A2B),
        navbarBg: Color(0x0D172A2B),
      );

  final Color white;
  final Color greenBg;
  final Color mainGreenLight;
  final Color mainGreenDark;
  final Color border;
  final Color textDarkGreen;
  final Color textLightGreen;
  final Color subtext;
  final Color icon;
  final Color red;
  final Color chipBg;
  final Color yellow;
  final Color redBg;
  final Color hint;
  final Color navbarBg;

  @override
  AppColorScheme copyWith({
    Color? white,
    Color? greenBg,
    Color? mainGreenLight,
    Color? mainGreenDark,
    Color? border,
    Color? textDarkGreen,
    Color? textLightGreen,
    Color? subtext,
    Color? icon,
    Color? red,
    Color? chipBg,
    Color? yellow,
    Color? redBg,
    Color? hint,
    Color? navbarBg,
  }) {
    return AppColorScheme(
      white: white ?? this.white,
      greenBg: greenBg ?? this.greenBg,
      mainGreenLight: mainGreenLight ?? this.mainGreenLight,
      mainGreenDark: mainGreenDark ?? this.mainGreenDark,
      border: border ?? this.border,
      textDarkGreen: textDarkGreen ?? this.textDarkGreen,
      textLightGreen: textLightGreen ?? this.textLightGreen,
      subtext: subtext ?? this.subtext,
      icon: icon ?? this.icon,
      red: red ?? this.red,
      chipBg: chipBg ?? this.chipBg,
      yellow: yellow ?? this.yellow,
      redBg: redBg ?? this.redBg,
      hint: hint ?? this.hint,
      navbarBg: navbarBg ?? this.navbarBg,
    );
  }

  @override
  ThemeExtension<AppColorScheme> lerp(
    ThemeExtension<AppColorScheme>? other,
    double t,
  ) {
    if (other is! AppColorScheme) return this;

    return AppColorScheme(
      white: Color.lerp(white, other.white, t)!,
      greenBg: Color.lerp(greenBg, other.greenBg, t)!,
      mainGreenLight: Color.lerp(mainGreenLight, other.mainGreenLight, t)!,
      mainGreenDark: Color.lerp(mainGreenDark, other.mainGreenDark, t)!,
      border: Color.lerp(border, other.border, t)!,
      textDarkGreen: Color.lerp(textDarkGreen, other.textDarkGreen, t)!,
      textLightGreen: Color.lerp(textLightGreen, other.textLightGreen, t)!,
      subtext: Color.lerp(subtext, other.subtext, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      red: Color.lerp(red, other.red, t)!,
      chipBg: Color.lerp(chipBg, other.chipBg, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
      redBg: Color.lerp(redBg, other.redBg, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      navbarBg: Color.lerp(navbarBg, other.navbarBg, t)!,
    );
  }
}
