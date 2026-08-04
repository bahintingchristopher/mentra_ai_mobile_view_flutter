import 'package:flutter/material.dart';

// Match the actual folder structure in your VS Code sidebar:
import 'views/screens/login_screen.dart'; // assuming login_screen.dart is in views/screens/
import 'views/pages/learner/learner_home.dart';
import 'views/pages/admin/admin_home.dart';
import 'views/pages/superadmin/superadmin_home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/learner_home': (context) => LearnerHome(),
        '/admin_home': (context) => const AdminHomeScreen(),
        '/superadmin_home': (context) => const SuperAdminHomeScreen(),
      },
    );
  }
}