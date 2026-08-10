// lib/app.dart
import 'package:flutter/material.dart';
import 'package:mentra_mobile_view/features/auth/login_screen.dart';
import 'package:mentra_mobile_view/learner/home/learner_home_screen.dart';
import 'package:mentra_mobile_view/admin/admin_home.dart';
import 'package:mentra_mobile_view/super_admin/superadmin_home.dart';
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
          
          // Original Light Theme Palette
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFE2E7F3), // Soft blue-tinted background
            cardColor: Colors.white, // Crisp white post cards
            colorScheme: const ColorScheme.light(
              surface: Colors.white,
              onSurface: Color(0xFF1E293B), // Dark slate heading/text
              secondaryContainer: Color(0xFFE0E7FF), // Soft purple tag fill
              onSecondaryContainer: Color(0xFF4F46E5), // Indigo tag text
            ),
          ),
          
          // Original Dark Theme Palette
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0D1322), // Deep dark navy outer frame
            cardColor: const Color(0xFF434B5E), // Muted grayish-blue post cards
            colorScheme: const ColorScheme.dark(
              surface: Color(0xFF1B2234), // Inner dark container background
              onSurface: Colors.white, // Crisp white text
              secondaryContainer: Color(0xFF3B3258), // Dark purple tag fill
              onSecondaryContainer: Color(0xFFA5B4FC), // Lavender tag text
            ),
          ),

          themeMode: currentMode,
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/learner_home': (context) => const LearnerHome(),
            '/admin_home': (context) => const AdminHomeScreen(),
            '/superadmin_home': (context) => const SuperAdminHomeScreen(),
          },
        );
      },
    );
  }
}