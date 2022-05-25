import 'package:flutter/material.dart';

const _primarySwatch = MaterialColor(0xfff44336, {
  50: Color(0xffffebee),
  100: Color(0xffffcdd2),
  200: Color(0xffef9a9a),
  300: Color(0xffe57373),
  400: Color(0xffef5350),
  500: Color(0xfff44336),
  600: Color(0xffe53935),
  700: Color(0xffd32f2f),
  800: Color(0xffc62828),
  900: Color(0xffb71c1c),
});

final themeData = ThemeData(
  primarySwatch: _primarySwatch,
);
