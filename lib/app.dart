import 'package:flutter/material.dart';
import 'shared/theme/app_theme.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';

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
