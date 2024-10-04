import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@singleton
class Constant {
  static const String appName = "D'Story";
  static const String localizationPath = 'assets/translations';
  static SharedPreferencesKeys sharedPreferencesKeys = SharedPreferencesKeys();
  static List<MaterialColor> get getColorList =>
      <MaterialColor>[Colors.purple, Colors.deepPurple];
  static List<Alignment> get getAligments => <Alignment>[
        Alignment.bottomLeft,
        Alignment.bottomRight,
        Alignment.topRight,
        Alignment.topLeft,
        Alignment.bottomLeft
      ];
}

@singleton
class SharedPreferencesKeys {
  final String token = 'token';
}
