import 'package:bloc_boilerplate/models/model.dart';
import 'package:flutter/material.dart';
import 'package:bloc_boilerplate/utils/utils.dart';

enum DarkOption { dynamic, alwaysOn, alwaysOff }

class AppTheme {
  ///Default font
  static const String defaultFont = "Raleway";

  ///List Font support
  static final List<String> fontSupport = [
    "ProximaNova",
    "Raleway",
    "Roboto",
    "Merriweather",
  ];

  ///Default Theme
  static final ThemeModel defaultTheme = ThemeModel.fromJson({
    "name": "default",
    "primary": Colors.blue.toHex,
    "secondary": Colors.blueAccent.toHex,
  });

  ///List Theme Support in Application
  static final List themeSupport = [
    {
      "name": "default",
      "primary": Colors.blue.toHex,
      "secondary": Colors.blueAccent.toHex,
    },
    {"name": "green", "primary": 'ff82B541', "secondary": "ffff8a65"},
    {"name": "orange", "primary": 'fff4a261', "secondary": "ff2A9D8F"},
  ].map((item) => ThemeModel.fromJson(item)).toList();

  ///Dark Theme option
  static DarkOption darkThemeOption = DarkOption.dynamic;

  ///Singleton factory
  static final AppTheme _instance = AppTheme._internal();

  factory AppTheme() {
    return _instance;
  }

  AppTheme._internal();
}
