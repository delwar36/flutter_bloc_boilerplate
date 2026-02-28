import 'package:flutter/material.dart';

class AppLanguage {
  ///Default Language
  static const Locale defaultLanguage = Locale("en");

  ///List Language support in Application
  static final List<Locale> supportLanguage = [const Locale("en")];

  ///Singleton factory
  static final AppLanguage _instance = AppLanguage._internal();

  factory AppLanguage() {
    return _instance;
  }

  AppLanguage._internal();
}
