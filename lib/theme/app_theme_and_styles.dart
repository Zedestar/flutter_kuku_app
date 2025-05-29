import 'package:flutter/material.dart';

ThemeData theAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.lightBlueAccent,
    brightness: Brightness.dark,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,

    // Background color for Scaffold
    scaffoldBackgroundColor:
        colorScheme.background, // Replaced Colors.grey[800]

    // Text styles
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: colorScheme.onBackground, // Better than onPrimary here
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: colorScheme.onBackground, // Text on scaffold background
      ),
    ),

    // AppBar styling
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary, // Icon and text color
      elevation: 4,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorScheme.onPrimary, // Make sure title text is readable
      ),
    ),

    // Elevated button styling
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Text button styling
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),

    // Outlined button styling
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: colorScheme.primary),
        foregroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Input fields (TextField, etc.)
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary),
      ),
      labelStyle: TextStyle(color: colorScheme.primary),
      hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
    ),

    // Card widget styling
    cardTheme: CardTheme(
      elevation: 4,
      color: colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(12),
    ),

    // FloatingActionButton styling
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    ),

    // Icon styling
    iconTheme: IconThemeData(
      color: colorScheme.primary,
      size: 28,
    ),

    // // BottomNavigationBar styling
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //   selectedItemColor: colorScheme.primary,
    //   unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
    //   backgroundColor: colorScheme.surface,
    // ),
  );
}
