// import 'package:flutter/material.dart';
// import 'app.dart';
// import 'theme/app_theme.dart';

// void main() {
//   AppTheme.configureSystemUI(); // Light by default
//   runApp(const NyatApp());
// }
import 'package:flutter/material.dart';
import 'app.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.configureSystemUI(isDark: false); // initial light mode
  runApp(const NyatApp());
}
