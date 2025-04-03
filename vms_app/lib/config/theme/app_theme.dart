import 'package:flutter/material.dart';

class AppTheme {
  // Core Colors
  static const Color primaryColor = Color(0xFFF0070FF);
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color black = Colors.black;
  static const Color backgroundColor = Color(0xFF1A1F28);
  static const Color bottomBarBgColor = Color.fromARGB(255, 16, 20, 27);

  // Custom Colors
  static const Color customBlue = Color.fromARGB(255, 60, 179, 235);
  static const Color customLightBlue = Color.fromARGB(255, 83, 177, 245);
  static const Color customRed = Color.fromARGB(255, 255, 17, 0);
  static const Color customYellowWithOrangeShade = Color(0xFFF59762);
  static const Color customGreen = Color(0xFF29D697);

  // Additional Utility Colors
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF2E7D32);
  static const Color disabledColor = Color(0xFFB0BEC5);

  // Light Theme (optional, for future scalability)
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        titleTextStyle: AppTextStyles.appbarText,
      ),
      textTheme: _buildTextTheme(),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: customLightBlue,
        error: errorColor,
      ),
    );
  }

  // Dark Theme (optional, for future scalability)
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        titleTextStyle: AppTextStyles.appbarText,
      ),
      textTheme: _buildTextTheme(),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: customLightBlue,
        error: errorColor,
        surface: bottomBarBgColor,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bottomBarBgColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: grey,
      ),
    );
  }

  // Centralized TextTheme for consistent typography
  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: AppTextStyles.heading,
      headlineMedium: AppTextStyles.appbarText,
      titleLarge: AppTextStyles.subheading,
      bodyMedium: AppTextStyles.description,
      bodySmall: AppTextStyles.body,
    );
  }
}

class AppTextStyles {
  // Headings
  static const TextStyle heading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w500,
    color: AppTheme.white,
    letterSpacing: 0.5,
  );

  static const TextStyle appbarText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppTheme.white,
    letterSpacing: 0.2,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppTheme.white,
    letterSpacing: 0.3,
  );

  // Body Text
  static const TextStyle description = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppTheme.white,
    height: 1.5,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white70,
    height: 1.4,
  );

  // Additional Text Styles
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppTheme.grey,
    height: 1.3,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppTheme.white,
    letterSpacing: 0.5,
  );

  static const TextStyle error = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppTheme.errorColor,
  );
}

// Extension for easy color access in widgets
extension ColorExtension on BuildContext {
  AppTheme get theme => AppTheme();
  AppTextStyles get textStyles => AppTextStyles();
}
