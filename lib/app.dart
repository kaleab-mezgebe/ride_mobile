// import 'package:flutter/material.dart';
// import 'theme/app_theme.dart';
// import 'screens/onboarding_screen.dart';

// class NyatApp extends StatelessWidget {
//   const NyatApp({Key? key}) : super(key: key);

//   // Global dark mode notifier
//   static final ValueNotifier<bool> isDarkMode = ValueNotifier(false);

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: isDarkMode,
//       builder: (_, darkMode, __) {
//         return MaterialApp(
//           title: "Nyat Passenger",
//           debugShowCheckedModeBanner: false,
//           theme: darkMode ? ThemeData.dark() : AppTheme.light(),
//           home: const OnboardingScreen(),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding_screen.dart';

class NyatApp extends StatefulWidget {
  const NyatApp({Key? key}) : super(key: key);

  static final ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  @override
  State<NyatApp> createState() => _NyatAppState();
}

class _NyatAppState extends State<NyatApp> {
  @override
  void initState() {
    super.initState();
    NyatApp.isDarkMode.addListener(() {
      // update system UI whenever dark mode changes
      AppTheme.configureSystemUI(isDark: NyatApp.isDarkMode.value);
      setState(() {}); // rebuild MaterialApp with new theme
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: NyatApp.isDarkMode,
      builder: (_, darkMode, __) {
        return MaterialApp(
          title: "Nyat Passenger",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          home: const OnboardingScreen(),
        );
      },
    );
  }
}
