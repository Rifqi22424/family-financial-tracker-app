import 'package:financial_family_tracker/core/consts/app_padding.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Define our blue colors
  static const lightBlue = Color(0xFF64B5F6); // Lighter blue for secondary
  static const darkBlue = Colors.orange; // Darker blue for pressed states
  static const dividerGrey = Color(0xFFE0E0E0); // Light grey for dividers

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Enable Material 3

    // Define the color scheme
    colorScheme: ColorScheme.light(
      primary: darkBlue,
      primaryContainer: lightBlue,
      secondary: lightBlue,
      secondaryContainer: lightBlue.withOpacity(0.7),
      surface: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onError: Colors.white,
    ),

    // Primary color swatch
    primarySwatch: Colors.blue,

    // Scaffold Background Color
    scaffoldBackgroundColor: const Color(0xFFFAF8F6),

    // Divider Theme - Mengatur warna garis pemisah
    dividerTheme: const DividerThemeData(
      color: dividerGrey,
      thickness: 1,
    ),

    // Data Table Theme - Mengatur warna border pada tabel
    dataTableTheme: DataTableThemeData(
      dividerThickness: 1,
      horizontalMargin: 16,
      columnSpacing: 24,
      headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
      // dataRowColor: dividerGrey,
    ),

    // Tab Bar Theme - Mengatur warna indicator dan label
    tabBarTheme: const TabBarTheme(
      indicatorColor: darkBlue,
      dividerColor: dividerGrey,
      labelColor: darkBlue,
      unselectedLabelColor: Colors.grey,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkBlue,
        padding: EdgeInsets.symmetric(
            horizontal: AppPadding.large, vertical: AppPadding.medium),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 16),
        headlineSmall: TextStyle(fontSize: 16, color: Colors.grey)),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBlue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: darkBlue),
        borderRadius: BorderRadius.circular(8),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: dividerGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: dividerGrey),
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: darkBlue,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: darkBlue,
      foregroundColor: Colors.white,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: darkBlue,
      unselectedItemColor: Colors.grey,
    ),

    // Switch, Checkbox, dan Radio Theme
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return darkBlue;
        }
        return null;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return darkBlue;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return darkBlue;
        }
        return null;
      }),
    ),
  );
}
