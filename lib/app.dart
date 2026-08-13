// lib/app.dart
import 'package:flutter/material.dart';

import 'package:mentra_mobile_view/features/auth/login_screen.dart';
import 'package:mentra_mobile_view/learner/home/learner_home_screen.dart';
import 'package:mentra_mobile_view/learner/shared/theme_controller.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // Light Theme
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFE2E7F3),
            cardColor: Colors.white,
            colorScheme: const ColorScheme.light(
              surface: Colors.white,
              onSurface: Color(0xFF1E293B),
              secondaryContainer: Color(0xFFE0E7FF),
              onSecondaryContainer: Color(0xFF4F46E5),
            ),
          ),

          // Dark Theme
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0D1322),
            cardColor: const Color(0xFF434B5E),
            colorScheme: const ColorScheme.dark(
              surface: Color(0xFF1B2234),
              onSurface: Colors.white,
              secondaryContainer: Color(0xFF3B3258),
              onSecondaryContainer: Color(0xFFA5B4FC),
            ),
          ),

          themeMode: currentMode,

          initialRoute: '/login',

          routes: {
            '/login': (context) => const LoginScreen(),

            '/learner_home': (context) => const LearnerHome(),
         
          },
        );
      },
    );
  }
}