// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safebite/core/theme/app_theme.dart';
import 'app/data/services/ai_services.dart';
import 'app/data/services/database_services.dart';
import 'app/data/services/storage_services.dart';
import 'core/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load env vars first
  // Initialize services
  await StorageService().init();
  await AIService().init();
  await DatabaseService().database;

  runApp(const SafeBiteApp());
}

class SafeBiteApp extends StatelessWidget {
  const SafeBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fruit Freshness Detector',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}