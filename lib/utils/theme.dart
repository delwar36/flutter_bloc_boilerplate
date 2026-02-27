import 'package:flutter/material.dart';
import 'package:basic_app/configs/config.dart';
import 'package:basic_app/models/model.dart';

class UtilTheme {
  static ThemeData getTheme({
    required ThemeModel theme,
    required Brightness brightness,
    required String font,
  }) {
    ColorScheme? colorScheme;
    switch (brightness) {
      case Brightness.light:
        colorScheme = ColorScheme.light(
          primary: theme.primary,
          secondary: theme.secondary,
        );
        break;
      case Brightness.dark:
        colorScheme = ColorScheme.dark(
          primary: theme.primary,
          secondary: theme.secondary,
        );
        break;
    }

    final isDark = colorScheme.brightness == Brightness.dark;
    final appBarColor = colorScheme.surface;
    final indicatorColor = isDark ? colorScheme.onSurface : colorScheme.primary;

    return ThemeData(
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarColor,
        foregroundColor: isDark ? Colors.white : Colors.black,
        shadowColor: isDark
            ? null
            : colorScheme.onSurface.withValues(alpha: 0.2),
      ),
      canvasColor: colorScheme.surface,
      scaffoldBackgroundColor: colorScheme.surface,
      cardColor: colorScheme.surface,
      dividerColor: colorScheme.onSurface.withValues(alpha: 0.12),
      applyElevationOverlayColor: isDark,
      colorScheme: colorScheme,
      fontFamily: font,
      tabBarTheme: TabBarThemeData(indicatorColor: indicatorColor),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        shape: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(thickness: 0.8),
      bottomAppBarTheme: BottomAppBarThemeData(
        color: colorScheme.surface,
        shape: const CircularNotchedRectangle(),
      ),
    );
  }

  static String langDarkOption(DarkOption option) {
    switch (option) {
      case DarkOption.dynamic:
        return "dynamic_theme";
      case DarkOption.alwaysOff:
        return "always_off";
      default:
        return "always_on";
    }
  }

  ///Singleton factory
  static final _instance = UtilTheme._internal();

  factory UtilTheme() {
    return _instance;
  }

  UtilTheme._internal();
}
