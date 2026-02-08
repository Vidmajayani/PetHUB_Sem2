import 'package:flutter/material.dart';

/// Base colors
final MaterialColor primaryPurple = Colors.deepPurple;
final Color onPrimaryPurple = Colors.white;

/// Light Theme
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: primaryPurple.shade500,
    onPrimary: onPrimaryPurple,
    secondary: primaryPurple.shade200,
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    error: Colors.red.shade700,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 2,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.deepPurple, width: 2.0),
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
);

/// Dark Theme - Improved
final ThemeData appDarkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: primaryPurple.shade300,        // stronger purple
    onPrimary: onPrimaryPurple,
    secondary: primaryPurple.shade700,      // deeper secondary
    onSecondary: Colors.white,
    surface: const Color(0xFF1E1E1E),       // dark surface for cards/containers
    onSurface: Colors.white,
    error: Colors.red.shade600,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1B1B1B),     // darker app bar
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 2,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E1E1E),     // dark input fields
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryPurple.shade300, width: 2.0),
      borderRadius: BorderRadius.circular(12.0),
    ),
    hintStyle: TextStyle(color: Colors.grey.shade400),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryPurple.shade300,  // brighter purple for buttons
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
  cardColor: const Color(0xFF1E1E1E),        // cards dark color
  dividerColor: Colors.grey.shade700,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
);