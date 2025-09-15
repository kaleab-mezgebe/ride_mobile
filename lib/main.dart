import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'shared/theme/app_theme.dart';
import '../features/auth/presentation/controllers/user_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.configureSystemUI(isDark: false); // initial light mode
  Get.put(UserController()); // Singleton instance
  runApp(const NyatApp());
}
