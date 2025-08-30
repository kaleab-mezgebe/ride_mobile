// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class AppTheme {
//   static const Color _primaryColor = Color(0xFF08B783);
//   static const Color _secondaryColor = Color(0xFF056B4C);
//   static const Color _accentColor = Color(0xFF4DD6A2);

//   static void configureSystemUI({bool isDark = false}) {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
//         systemNavigationBarColor: isDark ? Colors.black : Colors.white,
//         systemNavigationBarIconBrightness:
//             isDark ? Brightness.light : Brightness.dark,
//       ),
//     );
//   }

//   static ThemeData light() {
//     return ThemeData(
//       brightness: Brightness.light,
//       primaryColor: _primaryColor,
//       colorScheme: ColorScheme.light(
//         primary: _primaryColor,
//         secondary: _secondaryColor,
//         surface: Colors.white,
//         background: Colors.grey[50]!,
//         error: Colors.red[700]!,
//         onPrimary: Colors.white,
//         onSecondary: Colors.white,
//         onSurface: Colors.black,
//         onBackground: Colors.black,
//         onError: Colors.white,
//       ),
//       appBarTheme: const AppBarTheme(
//         backgroundColor: _primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         titleTextStyle: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           fontFamily: 'NotoSansEthiopic',
//         ),
//         systemOverlayStyle: SystemUiOverlayStyle(
//           statusBarColor: _primaryColor,
//           statusBarIconBrightness: Brightness.light,
//         ),
//       ),
//       textTheme: const TextTheme(
//         titleLarge: TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//           color: _primaryColor,
//           fontFamily: 'NotoSansEthiopic',
//         ),
//         bodyLarge: TextStyle(
//           fontSize: 16,
//           color: Colors.black87,
//           fontFamily: 'NotoSansEthiopic',
//         ),
//         bodyMedium: TextStyle(
//           fontSize: 14,
//           color: Colors.grey,
//           fontFamily: 'NotoSansEthiopic',
//         ),
//         labelLarge: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           fontFamily: 'NotoSansEthiopic',
//         ),
//       ),
//     );
//   }

//   static ThemeData dark() {
//     return ThemeData(
//       brightness: Brightness.dark,
//       primaryColor: _primaryColor,
//       scaffoldBackgroundColor: Colors.black,
//       colorScheme: ColorScheme.dark(
//         primary: _primaryColor,
//         secondary: _accentColor,
//         surface: Colors.grey[850]!, // slightly lighter than pure black
//         background: Colors.black,
//         error: Colors.red[400]!,
//         onPrimary: Colors.white,
//         onSecondary: Colors.white,
//         onSurface: Colors.white70, // readable text on dark surfaces
//         onBackground: Colors.white70,
//         onError: Colors.white,
//       ),
//       appBarTheme: const AppBarTheme(
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         titleTextStyle: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           fontFamily: 'NotoSansEthiopic',
//         ),
//         systemOverlayStyle: SystemUiOverlayStyle(
//           statusBarColor: Colors.black,
//           statusBarIconBrightness: Brightness.light,
//         ),
//       ),
//       textTheme: const TextTheme(
//         titleLarge: TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//           fontFamily: 'NotoSansEthiopic',
//         ),
//         bodyLarge: TextStyle(
//           fontSize: 16,
//           color: Colors.white70, // slightly dimmed white for reading comfort
//           fontFamily: 'NotoSansEthiopic',
//         ),
//         bodyMedium: TextStyle(
//           fontSize: 14,
//           color: Colors.white60, // more contrast than grey
//           fontFamily: 'NotoSansEthiopic',
//         ),
//         labelLarge: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.white, // ensure labels are visible
//           fontFamily: 'NotoSansEthiopic',
//         ),
//       ),
//       iconTheme: const IconThemeData(
//         color: Colors.white70, // default icon color on dark mode
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: _primaryColor, // keeps button green
//           foregroundColor: Colors.white, // button text
//         ),
//       ),
//       cardColor: Colors.grey[850], // for panels, bottom sheets
//       dividerColor: Colors.grey[700],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFF08B783);
  static const Color _secondaryColor = Color(0xFF056B4C);
  static const Color _accentColor = Color(0xFF4DD6A2);

  /// Global system UI config
  static void configureSystemUI({bool isDark = false}) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // keep transparent
        statusBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark, // Android
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light, // iOS
        systemNavigationBarColor: isDark ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: Colors.white,
        background: Colors.grey[50]!,
        error: Colors.red[700]!,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoSansEthiopic',
        ),
        // ❌ Removed systemOverlayStyle here
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
          fontFamily: 'NotoSansEthiopic',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontFamily: 'NotoSansEthiopic',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontFamily: 'NotoSansEthiopic',
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoSansEthiopic',
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: _primaryColor,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(
        primary: _primaryColor,
        secondary: _accentColor,
        surface: Colors.grey[850]!,
        background: Colors.black,
        error: Colors.red[400]!,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white70,
        onBackground: Colors.white70,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoSansEthiopic',
        ),
        // ❌ Removed systemOverlayStyle here
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'NotoSansEthiopic',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white70,
          fontFamily: 'NotoSansEthiopic',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.white60,
          fontFamily: 'NotoSansEthiopic',
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'NotoSansEthiopic',
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      cardColor: Colors.grey[850],
      dividerColor: Colors.grey[700],
    );
  }
}
